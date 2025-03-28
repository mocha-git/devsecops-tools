package tests

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSecureS3(t *testing.T) {
	t.Parallel()

	uniqueID := fmt.Sprintf("secure-bucket-%s-%d", random.UniqueId(), time.Now().Unix())

	terraformOptions := &terraform.Options{
		TerraformDir: "../deployments/minimal-setup",
		Vars: map[string]interface{}{
			"bucket_name": uniqueID,
		},
		EnvVars: map[string]string{
			"AWS_ACCESS_KEY_ID":     "<ton_access_key>",
			"AWS_SECRET_ACCESS_KEY": "<ton_secret_key>",
			"AWS_DEFAULT_REGION":    "eu-west-1",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	bucketID := terraform.Output(t, terraformOptions, "bucket_id")
	assert.Contains(t, bucketID, uniqueID)
}

