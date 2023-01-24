package awscompose

import (

	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
)

func CreateNetworkInterface(name string, description string, subnetId string, securityGroupId string, privateIpAddress string) (networkInterfaceId string) {
	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)


	inputCreateNetworkInterfaceInput := &ec2.CreateNetworkInterfaceInput  {
		Description: &description,
		Groups: []*string{
			aws.String(securityGroupId),
		},
		PrivateIpAddress: aws.String(privateIpAddress),
		SubnetId: &subnetId,

	}
	result, err := svc.CreateNetworkInterface(inputCreateNetworkInterfaceInput)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				fmt.Println(aerr.Error())
			}
		} 
		return
	}
	fmt.Println(result)
	return *result.NetworkInterface.NetworkInterfaceId
}