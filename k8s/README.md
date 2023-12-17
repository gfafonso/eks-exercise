# Kubernetes Setup

[Documentation](Documentation.md)

## Cluster Permissions

To grant necessary permissions for the user created during infrastructure setup:

1. Retrieve the `aws-auth-configmap.yaml` file:

   ```shell
   kubectl -n kube-system get configmap aws-auth -o yaml > aws-auth-configmap.yaml
   ```

2. Open `aws-auth-configmap.yaml` and add the following lines before `kind: ConfigMap`:

   ```yaml
   mapUsers:
     - userarn: arn:aws:iam::<ACCOUNT_ID>:user/<USER_NAME>
       username: <USER_NAME>
       groups:
         - system:masters
   ```

3. Save the file and apply it to the cluster:

   ```shell
   kubectl -n kube-system apply -f aws-auth-configmap.yaml
   ```

## GitHub Accessibility

To integrate deployment with GitHub, follow these steps:

1. Get the `kubeconfig` file:

   ```shell
   CONTEXT=$(kubectl config current-context)
   kubectl config view --context=$CONTEXT --minify > kubeconfig.yaml
   ```

2. Replace the certificate authority in `kubeconfig.yaml` from your local `~/.kube/config` or AWS EKS Dashboard.

3. Encode `kubeconfig.yaml` in base64 (e.g., on macOS):

   ```shell
   openssl base64 -in kubeconfig.yaml -out KUBECONFIG
   ```

4. Add the content of `KUBECONFIG` as a secret to your GitHub repository.

## Load Balancer Controller Deployment

To enable automatic load balancer provisioning:

1. Install the controller and service account using `eksctl`:

   ```shell
   eksctl create iamserviceaccount --region eu-west-1 \
     --cluster=<cluster_name> \
     --namespace=kube-system \
     --name=aws-load-balancer-controller \
     --role-name AmazonEKSLoadBalancerControllerRole \
     --attach-policy-arn=arn:aws:iam::<account>:policy/AmazonEKS_AWS_Load_Balancer_Controller- \
     --approve
   ```

   **Note: Obtain role ARN from `terraform apply` output and policy ARN from AWS Console.**

2. Implement `cert-manager` for ALB certificates:

   ```shell
   kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.12.3/cert-manager.yaml
   ```

3. Download the controller manifest, edit `v2_5_4_full.yaml`, and replace `<CLUSTER_NAME>`:

   ```shell
   curl -Lo v2_5_4_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_full.yaml
   sed -i.bak -e '596,604d' ./v2_5_4_full.yaml
   sed -i.bak -e 's|your-cluster-name|gaf-techIT8hAQUX|' ./v2_5_4_full.yaml
   ```

4. Apply the files:

   ```shell
   curl -Lo v2_5_4_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_ingclass.yaml
   kubectl apply -f v2_5_4_full.yaml
   kubectl apply -f v2_5_4_ingclass.yaml
   ```

These steps configure permissions, GitHub integration, and load balancer controller deployment for your Kubernetes cluster.
