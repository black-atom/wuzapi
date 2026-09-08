package main

import "testing"

func TestShouldDownloadHeavyMedia(t *testing.T) {
	tests := []struct {
		name         string
		instanceName string
		want         bool
	}{
		{name: "crm prefix", instanceName: "crm_acme", want: true},
		{name: "exact prefix", instanceName: "crm_", want: true},
		{name: "crm in the middle", instanceName: "prod_crm_bot", want: false},
		{name: "unrelated name", instanceName: "sales_bot", want: false},
		{name: "empty name", instanceName: "", want: false},
		{name: "wrong case", instanceName: "CRM_acme", want: false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := shouldDownloadHeavyMedia(tt.instanceName); got != tt.want {
				t.Errorf("shouldDownloadHeavyMedia(%q) = %v; want %v", tt.instanceName, got, tt.want)
			}
		})
	}
}
