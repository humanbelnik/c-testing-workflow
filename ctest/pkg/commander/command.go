package commander

import (
	"encoding/json"
	"io/ioutil"
	"github.com/alexeyco/simpletable"
)

const (
	Reset  = "\033[0m"
	Red    = "\033[31m"
	Green  = "\033[32m"
	Yellow = "\033[33m"
	Blue   = "\033[34m"
	Purple = "\033[35m"
	Cyan   = "\033[36m"
	Gray   = "\033[37m"
	White  = "\033[97m"
)

type TestToken struct {
	Number string
	Test_type string
	Description string
	Code string
	Status string
}

type Tasks []TestToken


func ReadData(t *Tasks, SrcFile string) error {

	//tasks := *t
	data, err := ioutil.ReadFile(SrcFile)
	if err != nil || len(data) == 0 {
		return err 
	}

	err = json.Unmarshal(data, t)
	if err != nil {
		return err
	}
	return nil
} 

func (t *Tasks) ShowTasks() {
	tasks := *t
	table := simpletable.New()
	table.Header = &simpletable.Header {
		Cells: []*simpletable.Cell {
			{Align: simpletable.AlignCenter, Text: "№"},
			{Align: simpletable.AlignCenter, Text: "Type"},
			{Align: simpletable.AlignCenter, Text: "Description"},
			{Align: simpletable.AlignCenter, Text: "Return code"},
			{Align: simpletable.AlignCenter, Text: "Status"},
		},
	}

	var cells [][]*simpletable.Cell

	for _, item := range tasks {

		if item.Status == "OK" {
			item.Status = Green + item.Status + Reset
		} else {
			item.Status = Red + item.Status + Reset
		}
		cells = append(cells, *&[]*simpletable.Cell {
			{Text: item.Number},
			{Text: item.Test_type},
			{Text: item.Description},
			{Text: item.Code}, 
			{Text: item.Status},
		})
	}
	table.Body = &simpletable.Body{Cells: cells}
	table.SetStyle(simpletable.StyleRounded)
	table.Println()
}
