package main

import "testing"

func TestIsCRMInstance(t *testing.T) {
	tests := []struct {
		name         string
		instanceName string
		want         bool
	}{
		{name: "crm prefix", instanceName: "crm_acme", want: true},
		{name: "crm substring", instanceName: "prod_crm_bot", want: true},
		{name: "unrelated name", instanceName: "sales_bot", want: false},
		{name: "empty name", instanceName: "", want: false},
		{name: "wrong case", instanceName: "CRM_acme", want: false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := isCRMInstance(tt.instanceName); got != tt.want {
				t.Errorf("isCRMInstance(%q) = %v; want %v", tt.instanceName, got, tt.want)
			}
		})
	}
}
