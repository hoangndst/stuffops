1. Create a custom VPC network with a single subnet
gcloud compute networks create google-to-azure-vpc \
    --subnet-mode custom \
    --bgp-routing-mode global
2. Create one subnet to host the test VMs
gcloud compute networks subnets create subnet-central1  \
    --network google-to-azure-vpc \
    --region us-central1 \
    --range 10.1.1.0/24
3. Create the HA VPN gateway
gcloud compute vpn-gateways create ha-vpn-gw-a \
   --network google-to-azure-vpc \
   --region us-central1

NAME: ha-vpn-gw-a
INTERFACE0: 35.242.102.174
INTERFACE1: 35.220.83.101
INTERFACE0_IPV6:
INTERFACE1_IPV6:
NETWORK: google-to-azure-vpc
REGION: us-central1

4. Create a Cloud Router
gcloud compute routers create cloud-router \
    --region us-central1 \
    --network google-to-azure-vpc \
    --asn 65534

NAME: cloud-router
REGION: us-central1
NETWORK: google-to-azure-vpc

5. Create a peer VPN gateway for the Azure VPN

5.1. Create a single external peer VPN gateway with two interfaces:
gcloud compute external-vpn-gateways create azure-peer-gw \
     --interfaces 0=40.81.248.45,1=40.81.248.55

6. Create VPN tunnels
6.1. Create the VPN tunnel for interface 0:
gcloud compute vpn-tunnels create azure-tunnel-1 \
   --peer-external-gateway azure-peer-gw \
   --peer-external-gateway-interface 0  \
   --region us-central1  \
   --ike-version 2 \
   --shared-secret pP8cZd6wqJx1W4EY0py9oVyV0Moy0dPG \
   --router cloud-router \
   --vpn-gateway ha-vpn-gw-a \
   --interface 0

NAME: azure-tunnel-1
REGION: us-central1
GATEWAY: ha-vpn-gw-a
VPN_INTERFACE: 0
PEER_ADDRESS: 40.81.248.45

6.2. Create the VPN tunnel for interface 1:
gcloud compute vpn-tunnels create azure-tunnel-2 \
   --peer-external-gateway azure-peer-gw \
   --peer-external-gateway-interface 1  \
   --region us-central1  \
   --ike-version 2 \
   --shared-secret pP8cZd6wqJx1W4EY0py9oVyV0Moy0dPG \
   --router cloud-router \
   --vpn-gateway ha-vpn-gw-a \
   --interface 1

NAME: azure-tunnel-2
REGION: us-central1
GATEWAY: ha-vpn-gw-a
VPN_INTERFACE: 1
PEER_ADDRESS: 40.81.248.55

7. Create BGP sessions
7.1 For the first VPN tunnel, add a BGP interface to the Cloud Router:
gcloud compute routers add-interface cloud-router \
   --interface-name azure-tunnel-1-int-0 \
   --mask-length 30 \
   --vpn-tunnel azure-tunnel-1 \
   --ip-address 169.254.21.2 \
   --region us-central1
7.2 For the first VPN tunnel, add a BGP peer to the interface:
gcloud compute routers add-bgp-peer cloud-router \
   --peer-name azure-bgp-peer-1 \
   --peer-asn 65515 \
   --interface azure-tunnel-1-int-0 \
   --peer-ip-address 169.254.21.1 \
   --region us-central1
7.3. For the second VPN tunnel, add a BGP interface to the Cloud Router:
gcloud compute routers add-interface cloud-router \
   --interface-name azure-tunnel-2-int-1 \
   --mask-length 30 \
   --vpn-tunnel azure-tunnel-2 \
   --ip-address 169.254.22.1 \
   --region us-central1
7.4. For the second VPN tunnel, add a BGP peer to the interface:
gcloud compute routers add-bgp-peer cloud-router \
  --peer-name azure-bgp-peer-2 \
  --peer-asn 65515 \
  --interface azure-tunnel-2-int-1 \
  --peer-ip-address 169.254.22.2 \
  --region us-central1

8. On Google Cloud, configure a firewall rule that allows inbound ICMP traffic from your Azure VPN:
gcloud compute firewall-rules create allow-azure-icmp \
  --network default \
  --direction ingress \
  --action allow \
  --source-ranges 10.0.0.0/8 \
  --rules icmp

NAME: allow-azure-icmp
NETWORK: google-to-azure-vpc
DIRECTION: INGRESS
PRIORITY: 1000
ALLOW: icmp
DENY:
DISABLED: False



34.157.84.215
34.157.238.125