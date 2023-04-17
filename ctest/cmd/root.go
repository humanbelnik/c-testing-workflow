package cmd

import (
	"os"
	"fmt"
	"github.com/spf13/cobra"
	"ctest/pkg/commander"
) 

var rootCmd = &cobra.Command{
	Use:   "ctest",
	Short: "",
	Long: ``,
	Args: cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
	  filePath := "../../" + args[0] + "/.report.json"
	  tasks := commander.Tasks{}
	  err := commander.ReadData(&tasks, filePath)
	  if err != nil {
		  fmt.Fprintf(os.Stderr, "[ERR]: %s", err)
	  } 
	  tasks.ShowTasks()
	},
  }
  
  func Execute() {
	if err := rootCmd.Execute(); err != nil {
	  fmt.Println(err)
	  os.Exit(1)
	}
  }