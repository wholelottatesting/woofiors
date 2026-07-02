// Package config loads the Woofiors backend configuration from the
// environment. Configuration is explicit: an unset variable takes its
// documented default, but a variable that is *set but empty* is a
// misconfiguration and fails loudly. We never treat an empty string as "use
// the default", because that hides typos and makes runtime behavior depend on
// something no one can see.
package config

import (
	"fmt"
	"net"
)

// EnvAddr is the environment variable holding the HTTP listen address.
const EnvAddr = "WOOFIORS_ADDR"

// DefaultAddr is the listen address used when EnvAddr is unset. It is the one
// and only place a default lives.
const DefaultAddr = ":8080"

// Config is the fully-resolved backend configuration.
type Config struct {
	// Addr is the TCP address the HTTP server binds to (host:port).
	Addr string
}

// Load builds a Config from the environment via lookup, which has the
// semantics of os.LookupEnv: it reports whether a variable is present so we
// can distinguish "unset" (use the default) from "set but empty" (an error).
func Load(lookup func(string) (string, bool)) (Config, error) {
	addr := DefaultAddr
	if v, ok := lookup(EnvAddr); ok {
		if v == "" {
			return Config{}, fmt.Errorf("%s is set but empty: unset it to use the default (%q) or provide a valid host:port", EnvAddr, DefaultAddr)
		}
		if _, _, err := net.SplitHostPort(v); err != nil {
			return Config{}, fmt.Errorf("%s=%q is not a valid host:port: %w", EnvAddr, v, err)
		}
		addr = v
	}
	return Config{Addr: addr}, nil
}
