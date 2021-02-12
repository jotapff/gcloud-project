#gcloud alpha cloud-shell ssh
gcloud config set account josepedroferreirafranco@gmail.com
gcloud config set project project-272122

#VPCs
gcloud compute networks create vpc-172-18-hq \
    --subnet-mode=custom  \
    --bgp-routing-mode=regional 

gcloud compute networks create vpc-172-16 \
    --subnet-mode=custom  \
    --bgp-routing-mode=regional 

gcloud compute networks create vpc-192 \
    --subnet-mode=custom  \
    --bgp-routing-mode=regional 

gcloud compute networks create vpc-172-17 \
    --subnet-mode=custom  \
    --bgp-routing-mode=regional 

gcloud compute networks create vpc-172-18-sk \
    --subnet-mode=custom  \
    --bgp-routing-mode=regional 

#Subnet
gcloud compute networks subnets create sub-172-18-hq \
    --network=vpc-172-18-hq  \
    --range=172.18.0.0/29 \
    --region=europe-north1

gcloud compute networks subnets create sub-172-16 \
    --network=vpc-172-16 \
    --range=172.16.0.0/16 \
    --region=europe-north1

gcloud compute networks subnets create sub-192 \
    --network=vpc-192 \
    --range=192.168.0.0/24 \
    --region=europe-north1

gcloud compute networks subnets create sub-172-17 \
    --network=vpc-172-17 \
    --range=172.17.0.0/16 \
    --region=europe-west3

gcloud compute networks subnets create sub-172-18-sk \
    --network=vpc-172-18-sk \
    --range=172.18.0.8/29 \
    --region=europe-west3

#Firewall - INGRESS
gcloud compute firewall-rules create firewall172-18-hq  \
	--priority=1000 \
	--direction=INGRESS \
	--network=vpc-172-18-hq \
	--action=ALLOW \
	--rules=all

gcloud compute firewall-rules create firewall172-16 \
	--priority=1000 \
	--direction=INGRESS \
	--network=vpc-172-16 \
	--action=ALLOW \
	--rules=all

gcloud compute firewall-rules create firewall172-17 \
	--priority=1000 \
	--direction=INGRESS \
	--network=vpc-172-17 \
	--action=ALLOW \
	--rules=all

gcloud compute firewall-rules create firewall172-18-sk \
	--priority=1000 \
	--direction=INGRESS \
	--network=vpc-172-18-sk \
	--action=ALLOW \
	--rules=all

gcloud compute firewall-rules create firewall192 \
	--priority=1000 \
	--direction=INGRESS \
	--network=vpc-192 \
	--action=ALLOW \
	--rules=all

#RTRHQ - instância
gcloud compute instances create rtrhq \
	--machine-type=n1-standard-4 \
	--zone=europe-north1-a \
	--image=debian-10-buster-v20200309 --image-project=debian-cloud \
	--hostname=rtrhq.skills.pt \
	--network-interface subnet=sub-172-18-hq,private-network-ip=172.18.0.2  \
	--network-interface subnet=sub-172-16,private-network-ip=172.16.0.2,no-address  \
	--network-interface subnet=sub-192,private-network-ip=192.168.0.2,no-address  \
	--can-ip-forward \
	--tags=rtrhq \
	--metadata-from-file startup-script=rtrhq.sh

#Rotas
gcloud beta compute routes create dmz-to-rtrhq \
	--network=vpc-172-16 \
	--destination-range=0.0.0.0/0 \
	--next-hop-instance=rtrhq \
	--priority=1 \
	--next-hop-instance-zone=europe-north1-a

gcloud beta compute routes create cli-to-rtrhq \
	--network=vpc-192 \
	--destination-range=0.0.0.0/0 \
	--next-hop-instance=rtrhq \
	--priority=1 \
	--next-hop-instance-zone=europe-north1-a

#DMZ - instância
gcloud compute instances create dmz \
	--machine-type=g1-small \
	--zone=europe-north1-a \
	--image=debian-10-buster-v20200309 --image-project=debian-cloud \
	--hostname=dmz.skills.pt \
	--subnet=sub-172-16 --private-network-ip=172.16.0.3 \
	--no-address \
	--tags=dmz \
	--metadata-from-file startup-script=dmz.sh

#CLI - instância
gcloud compute instances create cli \
	--machine-type=g1-small \
	--zone=europe-north1-a \
	--image=debian-10-buster-v20200309 --image-project=debian-cloud \
	--hostname=cli.skills.pt \
	--subnet=sub-192 --private-network-ip=192.168.0.3 \
	--tags=cli \
	--no-address \
	--metadata-from-file startup-script=cli.sh

#RTRSK - instância
gcloud compute instances create rtrsk \
	--machine-type=n1-standard-2 \
	--zone=europe-west3-a \
	--image=debian-10-buster-v20200309 --image-project=debian-cloud \
	--hostname=rtrsk.euroskills.com \
	--network-interface subnet=sub-172-18-sk,private-network-ip=172.18.0.10  \
	--network-interface subnet=sub-172-17,private-network-ip=172.17.0.2,no-address  \
	--tags=rtrsk \
	--can-ip-forward \
	--metadata-from-file startup-script=sk.sh

#Rotas
gcloud beta compute routes create skills-to-rtrsk \
	--network=vpc-172-17 \
	--destination-range=0.0.0.0/0 \
	--next-hop-instance=rtrsk \
	--priority=1 \
	--next-hop-instance-zone=europe-west3-a

#euroskills - instância
gcloud compute instances create euroskills \
	--machine-type=g1-small \
	--zone=europe-west3-a \
	--image=debian-10-buster-v20200309 --image-project=debian-cloud \
	--hostname=euroskills.euroskills.com \
	--subnet=sub-172-17 --private-network-ip=172.17.0.3 \
	--tags=euroskills \
	--no-address \
	--metadata-from-file startup-script=euroskills.sh