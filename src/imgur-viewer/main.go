package main

import (
	"encoding/json"
	"fmt"
	"gopkg.in/qml.v1"
	"log"
	"net/http"
)

type image struct {
	ID          string `json:"id"`
	Description string `json:"description"`
	IsAlbum     bool   `json:"is_album"`
	Link        string `json:"link"`
	Title       string `json:"title"`
}

type album struct {
	Data struct {
		ID          string  `json:"id"`
		Description string  `json:"description"`
		Images      []image `json:"images"`
		IsAlbum     bool    `json:"is_album"`
		Link        string  `json:"link"`
		Title       string  `json:"title"`
	} `json:"data"`
}

type gallery struct {
	Data []image `json:"data"`
}

type control struct {
	Root    qml.Object
	K       int
	Images  []image
	Current image
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

	var imgurResp gallery

	if err := json.NewDecoder(resp.Body).Decode(&imgurResp); err != nil {
		log.Println(err)
	}

	ctrl.K = 0
	ctrl.Images = imgurResp.Data
	log.Println("Images :", len(imgurResp.Data))
	ctrl.Current = ctrl.Images[ctrl.K]

	win.Show()
	win.Wait()
	return nil
}

func getAlbumImages(id string) []image {
	var albumResp album

	resp, err := http.Get(fmt.Sprintf("https://api.imgur.com/3/gallery/album/%s", id))
	defer resp.Body.Close()

	if err != nil {
		log.Println(err)
	}

	if err := json.NewDecoder(resp.Body).Decode(&albumResp); err != nil {
		log.Println(err)
	}
	log.Println(albumResp)
	return albumResp.Data.Images
}

func (ctrl *control) MoveIteratorImageArray(n int) {
	go func() {
		ctrl.K += n
		ctrl.Current = ctrl.Images[ctrl.K]
		log.Println(ctrl.Current)
		qml.Changed(ctrl, &ctrl.Current)
	}()
}

func (ctrl *control) ImageStatusChanged(image qml.Object) {
	log.Println("Status changed")
	image.Set("paused", true)

	if ctrl.Current.IsAlbum {
		log.Println("It's an album")
		getAlbumImages(ctrl.Current.ID)
	}

	switch image.Property("status") {
	case 1: //loaded
		image.Set("paused", false)
		log.Println("Loaded")
	case 2: //loading
		log.Println("Loading..")
	case 3: //error
		log.Println("Error")
	}
}
