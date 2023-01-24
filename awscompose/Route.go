package awscompose

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"

)

func CreateRoute(cidrBlock string, internetGatewayId string, routeTableId string) {
	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)
	input := &ec2.CreateRouteInput{
		DestinationCidrBlock: &cidrBlock,
		GatewayId: &internetGatewayId,
		RouteTableId: &routeTableId,
	}
	result, err := svc.CreateRoute(input)
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
	return


}