package config

import "testing"

// envFrom builds a lookup func (os.LookupEnv shape) from a map. A key present
// in the map is "set" (even to ""); a missing key is "unset".
func envFrom(m map[string]string) func(string) (string, bool) {
	return func(k string) (string, bool) {
		v, ok := m[k]
		return v, ok
	}
}

// Requirement: when WOOFIORS_ADDR is unset, Load uses the single documented
// default. This is what makes `go run .` work out of the box.
func TestLoad_UnsetUsesDefault(t *testing.T) {
	cfg, err := Load(envFrom(nil))
	if err != nil {
		t.Fatalf("Load: unexpected error: %v", err)
	}
	if cfg.Addr != DefaultAddr {
		t.Errorf("Addr = %q, want default %q", cfg.Addr, DefaultAddr)
	}
}

// Requirement: an explicitly set, valid address overrides the default. This is
// the one supported way to change the bind address.
func TestLoad_SetOverridesDefault(t *testing.T) {
	cfg, err := Load(envFrom(map[string]string{EnvAddr: "127.0.0.1:9999"}))
	if err != nil {
		t.Fatalf("Load: unexpected error: %v", err)
	}
	if cfg.Addr != "127.0.0.1:9999" {
		t.Errorf("Addr = %q, want %q", cfg.Addr, "127.0.0.1:9999")
	}
}

// Requirement: an empty WOOFIORS_ADDR is a misconfiguration, not a request for
// the default. We fail loudly at startup rather than silently fall back, so a
// typo can never produce mystery behavior at runtime.
func TestLoad_SetButEmptyFails(t *testing.T) {
	_, err := Load(envFrom(map[string]string{EnvAddr: ""}))
	if err == nil {
		t.Fatal("Load: want error for empty WOOFIORS_ADDR, got nil")
	}
}

// Requirement: a syntactically invalid address is rejected at startup rather
// than deferred to a confusing ListenAndServe failure later.
func TestLoad_InvalidAddrFails(t *testing.T) {
	_, err := Load(envFrom(map[string]string{EnvAddr: "not-a-valid-addr"}))
	if err == nil {
		t.Fatal("Load: want error for invalid address, got nil")
	}
}
