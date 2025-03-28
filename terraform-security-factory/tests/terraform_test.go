package tests

import (
	"fmt"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSecureS3BucketCreation(t *testing.T) {
	t.Parallel()

	// Get the absolute path to the test directory
	testDir, err := os.Getwd()
	assert.NoError(t, err, "Failed to get current directory")

	// Construct the path to the deployment directory
	deploymentDir := filepath.Join(testDir, "..", "deployments", "minimal-setup")

	testCases := []struct {
		name        string
		environment string
	}{
		{"Production Bucket", "production"},
		{"Staging Bucket", "staging"},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			uniqueID := fmt.Sprintf("secure-bucket-%s-%d", 
				random.UniqueId(), 
				time.Now().Unix(),
			)

			terraformOptions := &terraform.Options{
				// Use the path to the deployment directory
				TerraformDir: deploymentDir,
				
				// Ensure terraform init is run
				NoColor: true,
				
				Vars: map[string]interface{}{
					"bucket_name":   uniqueID,
					"environment":   tc.environment,
					"region":        "eu-west-3",
				},
				
				// Optional: set environment variables if needed
				EnvVars: map[string]string{
					"AWS_REGION": "eu-west-3",
				},
			}

			// Ensure cleanup even if test fails
			defer func() {
				// Attempt to destroy resources, ignore errors
				terraform.Destroy(t, terraformOptions)
			}()

			// Run terraform init
			terraform.Init(t, terraformOptions)

			// Apply the terraform configuration
			terraform.Apply(t, terraformOptions)

			// Verify bucket ID
			bucketID := terraform.Output(t, terraformOptions, "bucket_id")
			assert.Contains(t, bucketID, uniqueID, "Bucket ID should contain unique identifier")
			
			// Additional assertions can be added here
			assert.NotEmpty(t, bucketID, "Bucket ID should not be empty")
		})
	}
}

// Additional test functions can be added here
func TestBucketSecurityFeatures(t *testing.T) {
	// Placeholder for additional security feature tests
	t.Skip("Implement detailed security feature tests")
}
