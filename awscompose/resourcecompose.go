package awscompose

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws/session"
    //"github.com/aws/aws-sdk-go/service/s3"
	//"github.com/google/uuid"
	

)

var globalConfig Config

type Config struct {
    Bucket string `json:"Bucket"`
}


func CreateBucket(name string) {

	fmt.Println("Entered Cloud")
    
	if globalConfig.Bucket == "" {
        
        globalConfig.Bucket = name
        
    }

	 // Initialize a session that the SDK uses to load
    // credentials from the shared credentials file (~/.aws/credentials)
    sess := session.Must(session.NewSessionWithOptions(session.Options{
        SharedConfigState: session.SharedConfigEnable,
    }))

	err := MakeBucket(sess, &globalConfig.Bucket)

    if err != nil {
		fmt.Println("Error Creating Bucket")
        fmt.Println(err)
    }
}
