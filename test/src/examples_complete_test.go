package test

import (
	"math/rand"
	"strconv"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano())
	randID := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randID}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		// We always include a random attribute so that parallel tests
		// and AWS resources do not interfere with each other
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	zoneID := terraform.Output(t, terraformOptions, "zone_id")
	zoneFilterIDs := terraform.OutputList(t, terraformOptions, "zone_filter_ids")
	zoneFirewallRuleIDs := terraform.OutputList(t, terraformOptions, "zone_firewall_rule_ids")
	zoneRecordHostnamesToIDs := terraform.OutputMap(t, terraformOptions, "zone_record_hostnames_to_ids")
	zonePageRuleTargetsToIDs := terraform.OutputMap(t, terraformOptions, "zone_page_rule_targets_to_ids")

	assert.Equal(t, "da5747c2b4f465c8628365724219235e", zoneID)
	assert.Contains(t, zoneRecordHostnamesToIDs, "api-"+randID+".test-automation.app")
	assert.Contains(t, zoneRecordHostnamesToIDs, "bastion-"+randID+".test-automation.app")
	assert.NotEmpty(t, zoneFilterIDs)
	assert.NotEmpty(t, zoneFirewallRuleIDs)
	assert.NotEmpty(t, zonePageRuleTargetsToIDs)
}
