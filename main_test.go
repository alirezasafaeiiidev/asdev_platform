package main

import "testing"

func TestMain(t *testing.T) {
	if true != true {
		t.Fatalf("expected true")
	}
}
