## Code setup
Applicational code is a basic webapp.
The main requirements is that it is in GitHub platform. All the code should be in a repository so that it can work as a "plug and play".

Some requirements are needed to successfully deploy the application.
There are 3 secrets that need to be added to the repository.

    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    KUBECONFIG
    
The AWS secrets belong to the user that is utilized to access the cluster. This is created by the infrastructure setup and can be retrieved by the `terraform state` file, which at this stage it is local. Otherwise, looking at the remote state would do the job.

We will touch in the `KUBECONFIG` secret later on.

The pipeline is ready to **test code**, and if successfull, it will **build the docker image**, **upload to the ECR** and **deploy to the EKS cluster**.
