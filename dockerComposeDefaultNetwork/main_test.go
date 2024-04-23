package main_test

import (
	"fmt"
	"os"
	"testing"
)

func TestHoge(t *testing.T) {
	fmt.Println(os.Getenv("HOGE"))
}
