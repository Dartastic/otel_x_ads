// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_x_ads/otel_x_ads.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_x_ads-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('stats.accounts records spend + engagements breakdown', () async {
    await tracedXAds<String>(
      operation: 'stats.accounts',
      invoke: () async => const XAdsCallResult(
        value: 'ok',
        result: XAdsResult(
          accountId: 'acc_1',
          fundingInstrumentId: 'fi_1',
          campaignId: 'c_1',
          lineItemId: 'li_1',
          objective: 'ENGAGEMENTS',
          productType: 'PROMOTED_TWEETS',
          bidStrategy: 'AUTO',
          entityStatus: 'ACTIVE',
          spendMicros: 5000000,
          currencyCode: 'USD',
          impressions: 75000,
          engagements: 3200,
          likes: 1800,
          retweets: 250,
          replies: 120,
          urlClicks: 950,
          statusCode: 200,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('x_ads stats.accounts')!);
    expect(a['x_ads.objective'], 'ENGAGEMENTS');
    expect(a['x_ads.bid.strategy'], 'AUTO');
    expect(a['x_ads.spend.micros'], 5000000);
    expect(a['x_ads.likes'], 1800);
    expect(a['x_ads.retweets'], 250);
    expect(a['x_ads.url_clicks'], 950);
  });

  test('HTTP 401 sets span error', () async {
    await tracedXAds<String>(
      operation: 'campaigns.create',
      invoke: () async => const XAdsCallResult(
        value: 'ok',
        result: XAdsResult(statusCode: 401),
      ),
    );
    expect(
      spans.findSpanByName('x_ads campaigns.create')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutXAdsInstrumentationAsync(() async {
      await tracedXAds<String>(
        operation: 'line_items.create',
        invoke: () async => const XAdsCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('x_ads '), isEmpty);
  });
}
