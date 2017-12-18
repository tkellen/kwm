# KWM on Google Cloud
> the setup for this is ridiculous

## Setup
1. Find your org id && billing account ids: `gcloud organizations list && gcloud beta billing accounts list`
2. `export CREDS=~/.config/gcloud/terraform.js`
3. export OID=<copy/paste an org id>
4. export AID=<copy/paste an account id>
5. export PROJECT=terraform-kwm-<something-custom>
6. export GOOGLE_CREDENTIALS=$(cat ${CREDS})
7. export GOOGLE_PROJECT=${PROJECT}
8. gcloud projects create ${PROJECT} --organization ${OID} --set-as-default
9. gcloud beta billing projects link ${PROJECT} --billing-account ${AID}
10. gcloud iam service-accounts create terraform --display-name "Terraform Admin"
11. gcloud iam service-accounts keys create ${CREDS} --iam-account terraform@${PROJECT}.iam.gserviceaccount.com
12. gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:terraform@${PROJECT}.iam.gserviceaccount.com --role roles/viewer
13. gcloud projects add-iam-policy-binding ${PROJECT} --member serviceAccount:terraform@${PROJECT}.iam.gserviceaccount.com --role roles/storage.admin
14. gcloud services enable cloudresourcemanager.googleapis.com
15. gcloud services enable compute.googleapis.com
16. gcloud services enable cloudbilling.googleapis.com
17. gcloud services enable iam.googleapis.com
18. gcloud organizations add-iam-policy-binding ${OID} --member serviceAccount:terraform@${PROJECT}.iam.gserviceaccount.com --role roles/resourcemanager.projectCreator
19. gcloud organizations add-iam-policy-binding ${OID} --member serviceAccount:terraform@${PROJECT}.iam.gserviceaccount.com --role roles/billing.user
20. `cd ../..`
21. `source settings`
22. `./kwm`
23. Follow the prompts.

## Notes
Still setting stuff up. Non-functional.
