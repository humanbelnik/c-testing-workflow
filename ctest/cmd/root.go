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
		var err error
		
		path, err := os.Getwd()
		if err != nil {
			fmt.Fprintf(os.Stderr, "[ERR]: %s", err)
			os.Exit(1)
		}
		fmt.Println(path)
		
		filePath := "../" + args[0] + "/func_tests/data/.report.json"
		tasks := commander.Tasks{}
		err = commander.ReadData(&tasks, filePath)
		if err != nil {
			fmt.Fprintf(os.Stderr, "[ERR]: %s", err)
			os.Exit(1)
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