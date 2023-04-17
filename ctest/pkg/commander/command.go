package commander

import (
	"encoding/json"
	"io/ioutil"
	"github.com/alexeyco/simpletable"
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
