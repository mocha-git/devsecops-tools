// main_test.go
//
// Run tests with: go test -v
// This file uses Terratest to validate the Terraform configuration.

package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestServerlessStack(t *testing.T) {
	t.Parallel()

	uniqueID := random.UniqueId()

	terraformOptions := &terraform.Options{
		// Point to the directory containing 'tftest.hcl' and Terragrunt configs
		TerraformDir: "../",

		// Override inputs if needed:
		// Vars can also be passed here if you prefer direct Terraform usage
		// Vars: map[string]interface{}{
		// 	"project_name":          "test-project",
		// 	"aws_region":            "us-west-2",
		// 	"cognito_domain_prefix": "test-domain-prefix",
		// },
		EnvVars: map[string]string{
			// e.g., AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION
		},
	}

	// Clean up after test completes
	defer terraform.Destroy(t, terraformOptions)

	// Init, Plan, Apply
	terraform.Init(t, terraformOptions)
	terraform.Plan(t, terraformOptions)
	terraform.Apply(t, terraformOptions)

	// Fetch outputs
	apiEndpoint := terraform.Output(t, terraformOptions, "api_endpoint")
	userPoolID := terraform.Output(t, terraformOptions, "user_pool_id")

	// Basic checks to ensure outputs are not empty
	if apiEndpoint == "" {
		t.Fatalf("Expected a valid API endpoint, got empty string")
	}
	if userPoolID == "" {
		t.Fatalf("Expected a valid Cognito User Pool ID, got empty string")
	}

	t.Logf("Test run %s completed successfully. API Endpoint: %s", uniqueID, apiEndpoint)
	time.Sleep(5 * time.Second) // wait briefly before teardown
}

