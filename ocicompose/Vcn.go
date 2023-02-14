package ocicompose

import (
	"fmt"

	"github.com/oracle/oci-go-sdk/core"
	"github.com/oracle/oci-go-sdk/common"
	"github.com/oracle/oci-go-sdk/example/helpers"
	"context"
)

func CreateOciVcn(compartmentId string, name string, description string, cidrBlock string) (ociId string) {


	// initialize VirtualNetworkClient
	client, err := core.NewVirtualNetworkClientWithConfigurationProvider(common.DefaultConfigProvider())
	helpers.FatalIfError(err)
	ctx := context.Background()

	// create VCN
	createVcnRequest := core.CreateVcnRequest{
		RequestMetadata: helpers.GetRequestMetadataWithDefaultRetryPolicy(),
	}
	createVcnRequest.CompartmentId = common.String(compartmentId)
	createVcnRequest.DisplayName = common.String(name)
	createVcnRequest.CidrBlock = common.String(cidrBlock)

	
	resp, err := client.CreateVcn(ctx, createVcnRequest)
	
	helpers.FatalIfError(err)

	fmt.Println("VCN created")
	fmt.Println("Error")
	fmt.Println(err)
	fmt.Println("Response")
	fmt.Println(resp)
	return *resp.Id

}