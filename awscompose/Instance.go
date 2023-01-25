package awscompose

import (

	"fmt"

	"encoding/base64"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"

)

func RunInstance(imageId string, instanceType string, networkInterfaceId string) (instanceId string){


	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

   var userDataString= `#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
`
    encodedStr := base64.StdEncoding.EncodeToString([]byte(userDataString))
               


	svc := ec2.New(sess)

	

	input := &ec2.RunInstancesInput {
		ImageId: aws.String(imageId),
		InstanceType: aws.String(instanceType),
		MinCount: aws.Int64(1),
		MaxCount: aws.Int64(1),
		NetworkInterfaces: []*ec2.InstanceNetworkInterfaceSpecification{ 
			{
				DeviceIndex: aws.Int64(0),
				NetworkInterfaceId: &networkInterfaceId,
			},
		},
		UserData: aws.String(encodedStr),
		KeyName: aws.String("connect-key"),
		
	}

	result, err := svc.RunInstances(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			// Print the error, cast err to awserr.Error to get the Code and
			// Message from an error.
			fmt.Println(err.Error())
		}
		return
	}

	fmt.Println(result)
	return *result.Instances[0].InstanceId









}