package awscompose

import (

	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
)

func CreateAndAttachInternetGateway(vpcId string) (internetGatewayId string) {
	
	internetGatewayId = CreateInternetGateway()
	AttachInternetGateway(vpcId, internetGatewayId);
	return internetGatewayId
}

func AttachInternetGateway(vpcId string, internetGatewayId string) {

	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)

	input := &ec2.AttachInternetGatewayInput{
		InternetGatewayId: aws.String(internetGatewayId),
		VpcId:             aws.String(vpcId),
	}
	
	result, err := svc.AttachInternetGateway(input)
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
	
}


func CreateInternetGateway () (internetGatewayId string){

	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)


	inputCreateInternetGatewayInput := &ec2.CreateInternetGatewayInput  {
	}

	result, err := svc.CreateInternetGateway(inputCreateInternetGatewayInput)
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
	return *result.InternetGateway.InternetGatewayId

}