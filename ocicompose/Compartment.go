package ocicompose

import (
	"fmt"
	
	"github.com/oracle/oci-go-sdk/identity"
	"github.com/oracle/oci-go-sdk/common"
	"github.com/oracle/oci-go-sdk/example/helpers"
	"context"
)

func CreateOciCompartment(parentCompartmentId string, name string, description string) (ociId string) {
	
	c, _ := identity.NewIdentityClientWithConfigurationProvider(common.DefaultConfigProvider())

	// The OCID of the tenancy containing the compartment.
	//tenancyID, err := common.DefaultConfigProvider().TenancyOCID()
	//helpers.FatalIfError(err)

	ctx := context.Background()

	cpSource :=  createCompartment(ctx, c, parentCompartmentId, name, description)
	fmt.Println(cpSource)
	return *cpSource
}

func createCompartment(ctx context.Context, client identity.IdentityClient, parentCompartmentId string, compartmentName string, description string) *string {
	
	detail := identity.CreateCompartmentDetails{
		CompartmentId: &parentCompartmentId,
		Name:          &compartmentName,
		Description:   &description,

	}
	request := identity.CreateCompartmentRequest{
		CreateCompartmentDetails: detail,
		RequestMetadata:          helpers.GetRequestMetadataWithDefaultRetryPolicy(),
	}
	
	resp, _ := client.CreateCompartment(ctx, request)
	
	fmt.Println(resp)
	

	return resp.Id
}
