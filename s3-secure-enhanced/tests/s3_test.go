package test

import (
	"context"
	"fmt"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/aws/aws-sdk-go-v2/service/s3/types"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestS3SecureModule(t *testing.T) {
	t.Parallel()

	// 📍 Configuration
	awsRegion := "us-east-1"
	uniqueID := strings.ToLower(random.UniqueId())
	testBucketName := fmt.Sprintf("s3-secure-test-%s", uniqueID)
	logBucketName := fmt.Sprintf("s3-logs-%s", uniqueID)

	// 🔧 Préparation bucket de logs
	aws.CreateS3Bucket(t, awsRegion, logBucketName)
	defer aws.DeleteS3Bucket(t, awsRegion, logBucketName)

	// ⚙️ Configuration Terraform
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		Vars: map[string]interface{}{
			"bucket_name":    testBucketName,
			"logging_bucket": logBucketName,
			"tags": map[string]string{
				"Environment": "test",
				"Project":     "s3-secure",
			},
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}

	// 🧼 Cleanup automatique à la fin
	defer terraform.Destroy(t, terraformOptions)

	// 🚀 Init + Apply
	terraform.InitAndApply(t, terraformOptions)

	// 🎯 Vérifier que le bucket a été bien nommé
	bucketID := terraform.Output(t, terraformOptions, "bucket_id")
	assert.Contains(t, bucketID, testBucketName)

	// 📦 Initialiser client AWS SDK
	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(awsRegion))
	require.NoError(t, err, "impossible de charger la configuration AWS")

	s3Client := s3.NewFromConfig(cfg)

	t.Run("EncryptionEnabled", func(t *testing.T) {
		encryptionOutput, err := s3Client.GetBucketEncryption(context.TODO(), &s3.GetBucketEncryptionInput{
			Bucket: &testBucketName,
		})
		require.NoError(t, err, "impossible de récupérer la configuration de chiffrement")

		require.NotNil(t, encryptionOutput.ServerSideEncryptionConfiguration)
		rules := encryptionOutput.ServerSideEncryptionConfiguration.Rules
		require.NotEmpty(t, rules, "aucune règle de chiffrement trouvée")

		defaultEncryption := rules[0].ApplyServerSideEncryptionByDefault
		require.NotNil(t, defaultEncryption)
		assert.Equal(t, types.ServerSideEncryptionAes256, defaultEncryption.SSEAlgorithm)
	})

	t.Run("LoggingEnabled", func(t *testing.T) {
		logOutput, err := s3Client.GetBucketLogging(context.TODO(), &s3.GetBucketLoggingInput{
			Bucket: &testBucketName,
		})
		require.NoError(t, err, "impossible de récupérer la configuration de logs")

		require.NotNil(t, logOutput.LoggingEnabled)
		assert.Equal(t, logBucketName, *logOutput.LoggingEnabled.TargetBucket)
	})
}

