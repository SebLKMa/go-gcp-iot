# go-gcp-iot
Go Google Cloud Platform IoT Projects  

https://console.cloud.google.com/home/dashboard?project=savvy-girder-314608  
https://console.cloud.google.com/iot/locations/asia-east1/registries/seb-registry/overview?project=savvy-girder-314608  
https://console.cloud.google.com/iot/locations/asia-east1/registries/seb-registry/devices/details/seb-device/authentication?project=savvy-girder-314608  


## Setup

Though Cloud Shell has the Go language runtime pre-installed, you will need some other libraries. Install them with this command [See](https://cloud.google.com/community/tutorials/cloud-iot-hybrid):  
```sh
go get cloud.google.com/go/pubsub cloud.google.com/go/compute/metadata github.com/eclipse/paho.mqtt.golang
```

## References

https://cloud.google.com/community/tutorials/cloud-iot-hybrid  

## GitHub References
```sh
$ git push origin main
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 748 bytes | 748.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To https://github.com/SebLKMa/go-gcp-iot.git
   f6ba333..f239267  main -> main

$ git pull origin main
From https://github.com/SebLKMa/go-gcp-iot
 * branch            main       -> FETCH_HEAD
Already up to date.
```  
[GitHub Personal Access Token](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)  


## Google Cloud IoT Quick Start
Follow steps from https://cloud.google.com/iot/docs/quickstart  

```sh
gcloud compute project-info describe --project savvy-girder-314608
```

### Create Topic Subscription
```sh
gcloud pubsub subscriptions create \
    projects/savvy-girder-314608/subscriptions/my-subscription \
    --topic=projects/savvy-girder-314608/topics/seb-device-events
```

To revert your SDK to the previously installed version, you may run:
  `$ gcloud components update --version 341.0.0`  

## TLS Certs

From https://cloud.google.com/iot/docs/quickstart, we generated the certs and keys. Copy them to local working directory:
```sh
cp ~/gcp/seb-keys/roots.pem .
cp ~/gcp/seb-keys/rsa_private.pem seb-device.key.pem
```

## MQTT Publish using this Go app
This Go app credits to (Daz Wilkin's article)[https://medium.com/google-cloud/google-cloud-iot-core-golang-b130f65951ba].

In theory, you can build Go app to a hardware platform binary and deploy to an actual physical IoT device, e.g. Raspberry PI, BeagleBone, Weidmueller etc.

Typical steps are:  
1. Build Go app as binary.
2. Copy binary, roots.pem and seb-device.key.pem to actual device.
3. For docker containers, Dockerfile should contain similar files in docker image.

```sh
vera@ubuntu:~/gcp/github.com/go-gcp-iot/mqtt-pub$ ./start.sh 
2021/07/07 00:28:48 [main] Entered
2021/07/07 00:28:48 [main] Flags
2021/07/07 00:28:48 [main] Loading Google's roots
2021/07/07 00:28:48 [main] Creating TLS Config
2021/07/07 00:28:48 [main] Creating MQTT Client Options
2021/07/07 00:28:48 [main] Broker 'ssl://mqtt.googleapis.com:8883'
2021/07/07 00:28:48 [main] Load Private Key
2021/07/07 00:28:48 [main] Parse Private Key
2021/07/07 00:28:48 [main] Sign String
2021/07/07 00:28:48 [main] MQTT Client Connecting
2021/07/07 00:28:48 [main] Creating Subscription
2021/07/07 00:28:48 [main] Publishing Messages
2021/07/07 00:28:48 [main] Publishing Message #0
2021/07/07 00:28:48 [main] Publishing Message #1
2021/07/07 00:28:48 [main] Publishing Message #2
2021/07/07 00:28:48 [main] Publishing Message #3
2021/07/07 00:28:48 [main] Publishing Message #4
2021/07/07 00:28:48 [main] Publishing Message #5
2021/07/07 00:28:48 [main] Publishing Message #6
2021/07/07 00:28:48 [main] Publishing Message #7
2021/07/07 00:28:48 [main] Publishing Message #8
2021/07/07 00:28:48 [main] Publishing Message #9
2021/07/07 00:28:48 [main] MQTT Client Disconnecting
2021/07/07 00:28:48 [main] Done
```

### MQTT Publish using NodeJS sample
```sh
node cloudiot_mqtt_example_nodejs.js \
    mqttDeviceDemo \
    --projectId=savvy-girder-314608 \
    --cloudRegion=asia-east1 \
    --registryId=seb-registry \
    --deviceId=seb-device \
    --privateKeyFile=rsa_private.pem \
    --serverCertFile=roots.pem \
    --numMessages=25 \
    --algorithm=RS256
```

### Subscribe using gcloud command line (message displayed on DATA column)
```sh
gcloud pubsub subscriptions pull --auto-ack \
    projects/savvy-girder-314608/subscriptions/my-subscription
┌───────────────────────────────────┬──────────────────┬──────────────┬───────────────────────────────────┬──────────────────┐
│                DATA               │    MESSAGE_ID    │ ORDERING_KEY │             ATTRIBUTES            │ DELIVERY_ATTEMPT │
├───────────────────────────────────┼──────────────────┼──────────────┼───────────────────────────────────┼──────────────────┤
│ seb-registry/seb-device-payload-9 │ 2456435398905406 │              │ deviceId=seb-device               │                  │
│                                   │                  │              │ deviceNumId=3232545143167413      │                  │
│                                   │                  │              │ deviceRegistryId=seb-registry     │                  │
│                                   │                  │              │ deviceRegistryLocation=asia-east1 │                  │
│                                   │                  │              │ projectId=savvy-girder-314608     │                  │
│                                   │                  │              │ subFolder=                        │                  │
└───────────────────────────────────┴──────────────────┴──────────────┴───────────────────────────────────┴──────────────────┘
```

### View Messages from GCP portal

https://console.cloud.google.com/cloudpubsub/subscription/detail/my-subscription?_ga=2.110006341.1132325014.1622011746-461699955.1621761599&project=savvy-girder-314608  
From the page's top options `EDIT | VIEW MESSAGES | CREATE SNAPSHOT` click on `VIEW MESSAGES`.  


