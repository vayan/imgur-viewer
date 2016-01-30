package main

import (
	"encoding/json"
	"gopkg.in/qml.v1"
	"log"
	"net/http"
)

type response struct {
	Data []image `json:"data"`
}

type image struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Link        string `json:"link"`
}

type control struct {
	Root   qml.Object
	K      int
	Images []image
	Source string
}

func main() {
	err := qml.Run(run)
	if err != nil {
		log.Fatal(err)
	}
}

func run() error {
	engine := qml.NewEngine()
	component, err := engine.LoadFile("share/imgur-viewer/main.qml")
	if err != nil {
		return err
	}

	ctrl := control{}
	context := engine.Context()
	context.SetVar("ctrl", &ctrl)

	win := component.CreateWindow(nil)
	ctrl.Root = win.Root()

	resp, err := http.Get("https://api.imgur.com/3/gallery/hot/viral/0.json")
	defer resp.Body.Close()

	var imgurResp response

	if err := json.NewDecoder(resp.Body).Decode(&imgurResp); err != nil {
		log.Println(err)
	}

	ctrl.K = 0
	ctrl.Images = imgurResp.Data
	ctrl.Source = ctrl.Images[ctrl.K].Link

	win.Show()
	win.Wait()
	return nil
}

func (ctrl *control) Next() {
	go func() {
		ctrl.K++
		ctrl.Source = ctrl.Images[ctrl.K].Link
		log.Println(ctrl.Source)
		qml.Changed(ctrl, &ctrl.Source)
	}()
}
