package handlers

import (
	"database/sql"
	"html/template"
	"log"
	"net/http"
	"path/filepath"
)

// Handler holds dependencies for HTTP handlers
type Handler struct {
	db        *sql.DB
	templates *template.Template
}

// New creates a new Handler with the given database connection
func New(db *sql.DB) *Handler {
	// Parse all templates
	tmpl, err := template.ParseGlob(filepath.Join("web", "templates", "*.html"))
	if err != nil {
		log.Fatalf("Failed to parse templates: %v", err)
	}

	// Parse page templates
	tmpl, err = tmpl.ParseGlob(filepath.Join("web", "templates", "pages", "*.html"))
	if err != nil {
		log.Fatalf("Failed to parse page templates: %v", err)
	}

	// Parse partial templates
	tmpl, err = tmpl.ParseGlob(filepath.Join("web", "templates", "partials", "*.html"))
	if err != nil {
		log.Fatalf("Failed to parse partial templates: %v", err)
	}

	return &Handler{
		db:        db,
		templates: tmpl,
	}
}

// render executes a template with the layout
func (h *Handler) render(w http.ResponseWriter, page string, data any) {
	// Create a wrapper that includes the page content
	pageData := map[string]any{
		"Content": page,
		"Data":    data,
	}

	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := h.templates.ExecuteTemplate(w, "layout", pageData); err != nil {
		log.Printf("Template error: %v", err)
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
	}
}

// renderPartial executes a partial template (for HTMX responses)
func (h *Handler) renderPartial(w http.ResponseWriter, name string, data any) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := h.templates.ExecuteTemplate(w, name, data); err != nil {
		log.Printf("Template error: %v", err)
		http.Error(w, "Internal Server Error", http.StatusInternalServerError)
	}
}

// hasDB returns true if database is available
func (h *Handler) hasDB() bool {
	return h.db != nil
}
