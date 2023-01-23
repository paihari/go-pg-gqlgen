package awscompose

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
)

func CreateVpc(cidrBlock string)  (vpcId string){
	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)
	input := &ec2.CreateVpcInput{
		CidrBlock: aws.String(cidrBlock),		
		
	}
	result, err := svc.CreateVpc(input)
	fmt.Println(err != nil)
	
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				fmt.Println(aerr.Error())
			}
		}
	}
	fmt.Println(result)
	return *result.Vpc.VpcId

}