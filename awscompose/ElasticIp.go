package awscompose

import (

	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"

)

func ReleaseElasticIpAddress(allocationId string) {
	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)

	input := &ec2.ReleaseAddressInput{
		AllocationId:       &allocationId,
	}

	result, err := svc.ReleaseAddress(input)
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
}

func CreateAndAssociateElasticIp(networkInterfaceId string) (allocationId string, ipAddress string){
	allocationId, ipAddress = AllocateElasticIpAddress()
	AssociateElasticIpAddress(allocationId, networkInterfaceId)
	return allocationId, ipAddress
}

func AssociateElasticIpAddress(allocationId string, networkInterfaceId string) (associationId string){

	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)

	input := &ec2.AssociateAddressInput{
		AllocationId:       &allocationId,
		NetworkInterfaceId: &networkInterfaceId,
	}

	result, err := svc.AssociateAddress(input)
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
	return *result.AssociationId
	
}

func AllocateElasticIpAddress() (allocationId string, ipAddress string){

	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)

	input := &ec2.AllocateAddressInput{
		Domain: aws.String("vpc"),
	}

	result, err := svc.AllocateAddress(input)
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
	return *result.AllocationId, *result.PublicIp



}

// To allocate an Elastic IP address for EC2-VPC
// This example allocates an Elastic IP address to use with an instance in a VPC.
func ExampleEC2_AllocateAddress_shared00() {

	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)

	input := &ec2.AllocateAddressInput{
		Domain: aws.String("vpc"),
	}

	result, err := svc.AllocateAddress(input)
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
}