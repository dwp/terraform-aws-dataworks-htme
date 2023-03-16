package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	// "github.com/stretchr/testify/assert"

	"path/filepath"

	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

// Terratest functions for testing the ses notifcation module
func TestHtme(t *testing.T) {
	t.Parallel()

	// AWS Region set as eu-west-1 as standard.
	awsRegion := "eu-west-1"

	// set up variables for other module variables so assertions may be made on them later

	// Terraform plan.out File Path
	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../..", "example/")
	planFilePath := filepath.Join(exampleFolder, "plan.out")


	terraformOptionsHtme := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../example",
		Upgrade:      true,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{

		},

		//Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},

		// Configure a plan file path so we can introspect the plan and make assertions about it.
		PlanFilePath: planFilePath,
	})

	// website::tag::2::Run `terraform init`, `terraform plan`, and `terraform show` and fail the test if there are any errors
	plan := terraform.InitAndPlanAndShowWithStruct(t, terraformOptionsHtme)


	// // At the end of the test, run `terraform destroy` to clean up any resources that were created
	// defer terraform.Destroy(t, terraformOptionsHtme)

	// // This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	// terraform.InitAndApply(t, terraformOptionsHtme)

	// website::tag::3::Use the go struct to introspect the plan values.
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "aws_s3_bucket.compaction")
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "aws_s3_bucket.manifest_bucket")
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "aws_sns_topic.export_status_sns_fulls")
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "aws_sns_topic.export_status_sns_incrementals")
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "aws_dynamodb_table.terratest_data_pipeline_metadata")
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "aws_subnet.htme[0]")
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "aws_subnet.terratest_vpc_endpoints[0]")
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "module.terratest_htme.aws_launch_template.htme")




	// // Run `terraform output` to get the value of an output variable
	// compactionbucketID := terraform.Output(t, terraformOptionsHtme, "compaction_bucket.id")
	// manifestbucketID := terraform.Output(t, terraformOptionsHtme, "manifest_bucket.id")
	// snstopicfullName := terraform.Output(t, terraformOptionsHtme, "export_status_sns_fulls.name")
	// snstopicincrementalName := terraform.Output(t, terraformOptionsHtme, "export_status_sns_incrementals.name")
	// asgName := terraform.Output(t, terraformOptionsHtme, "asg_name")
	// sgID := terraform.Output(t, terraformOptionsHtme, "sg_id")


	// // Verify that our Bucket has been created
	// assert.Equal(t, compactionbucketID, "terratest-compaction-bucket", "Bucket ID must match")
	// assert.Equal(t, manifestbucketID, "terratest-manifest-bucket", "Bucket ID must match")
	// assert.Equal(t, snstopicfullName, "export_status_sns_fulls", "Topic name must match")
	// assert.Equal(t, snstopicincrementalName, "export_status_sns_incrementals", "Topic name must match")
	// assert.Equal(t, asgName, "htme_asg", "ASG name must match")


	// lengthOfsgID := len(sgID)
	// // Verify the SG parameters
	// assert.NotEqual(t, lengthOfsgID, 0, "SG ID Output MUST be populated")

}
