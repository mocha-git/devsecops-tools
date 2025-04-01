package main

import (
    "fmt"
    "log"
    "net/http"

    "go.opentelemetry.io/otel"
    "go.opentelemetry.io/otel/exporters/otlp/otlphttp"
    "go.opentelemetry.io/otel/sdk/resource"
    "go.opentelemetry.io/otel/sdk/trace"
    semconv "go.opentelemetry.io/otel/semconv/v1.12.0"
)

func main() {
    exporter, err := otlphttp.New()
    if err != nil {
        log.Fatalf("Erreur création exporter OTLP: %v", err)
    }

    tp := trace.NewTracerProvider(
        trace.WithBatcher(exporter),
        trace.WithResource(resource.NewWithAttributes(
            semconv.SchemaURL,
            semconv.ServiceNameKey.String("my-go-service"),
        )),
    )
    otel.SetTracerProvider(tp)

    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        tracer := otel.Tracer("my-go-service")
        _, span := tracer.Start(r.Context(), "rootHandler")
        defer span.End()

        fmt.Fprintf(w, "Hello from instrumented service!")
    })

    fmt.Println("Listening on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}

