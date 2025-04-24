<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Prometheus\CollectorRegistry;
use Prometheus\RenderTextFormat;

class PrometheusController extends Controller
{
    public function metrics()
    {
        $registry = new CollectorRegistry(true);
        $renderer = new RenderTextFormat();

        // Create a sample metric counter
        $counter = $registry->getOrRegisterCounter('laravel', 'requests_total', 'Total number of requests');
        $counter->inc();  // Increment the counter for each request

        // Render the metrics in the format Prometheus expects
        $metrics = $renderer->render($registry->getMetricFamilySamples());

        return response($metrics)
            ->header('Content-Type', RenderTextFormat::MIME_TYPE);
    }
}
