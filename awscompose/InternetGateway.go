package awscompose

import (

	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
)


func CreateInternetGateway (vpcId string) (){

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

	
	fmt.Println(*result.InternetGateway.InternetGatewayId)	
	return

}