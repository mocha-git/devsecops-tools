package tests

import (
	"fmt"
	"os"
	"testing"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sts"
)

func TestAWSCredentials(t *testing.T) {
	sess, err := session.NewSession()
	if err != nil {
		t.Fatalf("Erreur création session AWS: %v", err)
	}

	client := sts.New(sess)
	identity, err := client.GetCallerIdentity(nil)
	if err != nil {
		t.Fatalf("Erreur récupération identité AWS: %v", err)
	}

	fmt.Printf("Caller identity: %v\n", identity)

	// Affichage des variables pour debug
	fmt.Println("AWS_ACCESS_KEY_ID:", os.Getenv("AWS_ACCESS_KEY_ID"))
	fmt.Println("AWS_SECRET_ACCESS_KEY:", os.Getenv("AWS_SECRET_ACCESS_KEY"))
	fmt.Println("AWS_SESSION_TOKEN:", os.Getenv("AWS_SESSION_TOKEN"))
}

