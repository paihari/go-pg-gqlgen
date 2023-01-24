package awscompose


import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"

)

func CreateSecurityGroupAndAuthorizeIngressAndEgress(description string, name string, vpcId string) (securityGroupId string){
	securityGroupId = CreateSecurityGroup(description, name, vpcId)
	AuthorizeSecurityGroupIngress(securityGroupId)
	AuthorizeSecurityGroupEgress(securityGroupId)
	return securityGroupId
}

func AuthorizeSecurityGroupIngress(securityGroupid string) {

	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)

	input := &ec2.AuthorizeSecurityGroupIngressInput{
		GroupId: &securityGroupid,
		
		IpPermissions: []*ec2.IpPermission {
			{
				FromPort: aws.Int64(443),
				ToPort: aws.Int64(443),
				IpProtocol: aws.String("tcp"),
				IpRanges: []*ec2.IpRange{
					{
						CidrIp:      aws.String("0.0.0.0/0"),
						Description: aws.String("HTTPS"),
					},
				},
				
			},
			{
				FromPort: aws.Int64(80),
				ToPort: aws.Int64(80),
				IpProtocol: aws.String("tcp"),
				IpRanges: []*ec2.IpRange{
					{
						CidrIp:      aws.String("0.0.0.0/0"),
						Description: aws.String("HTTP"),
					},
				},
				
			},
			{
				FromPort: aws.Int64(22),
				ToPort: aws.Int64(22),
				IpProtocol: aws.String("tcp"),
				IpRanges: []*ec2.IpRange{
					{
						CidrIp:      aws.String("0.0.0.0/0"),
						Description: aws.String("SSH"),
					},
				},
				
			},
			


		} ,
	}

	result, err := svc.AuthorizeSecurityGroupIngress(input)
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


func AuthorizeSecurityGroupEgress(securityGroupid string) {

	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)

	input := &ec2.AuthorizeSecurityGroupEgressInput{
		GroupId: &securityGroupid,
		
		IpPermissions: []*ec2.IpPermission {
			{
				FromPort: aws.Int64(0),
				ToPort: aws.Int64(0),
				IpProtocol: aws.String("-1"),
				IpRanges: []*ec2.IpRange{
					{
						CidrIp:      aws.String("0.0.0.0/0"),
						
					},
				},
				
			},
			


		} ,
	}

	result, err := svc.AuthorizeSecurityGroupEgress(input)
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



func CreateSecurityGroup (description string, name string, vpcId string) (securityGroupId string){
	sess, errSess := session.NewSession(&aws.Config{ 
		Region: aws.String("us-east-1"),
	})

	if errSess != nil {
        fmt.Println(errSess.Error())
        return
    }

	svc := ec2.New(sess)

	input := &ec2.CreateSecurityGroupInput{
		Description: &description,
		GroupName: &name,
		VpcId: &vpcId,
	}

	result, err := svc.CreateSecurityGroup(input)
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
	return *result.GroupId
}
