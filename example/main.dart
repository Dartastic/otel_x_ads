// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_x_ads/otel_x_ads.dart';

/// Traces X Ads calls with OpenTelemetry.
///
/// `otel_x_ads` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each X Ads call in
/// [tracedXAds]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'x-ads-example');

  // Wraps an X Ads API call in a CLIENT span.
  final xAdsId = await tracedXAds<String>(
    operation: 'campaigns.create',
    invoke: () async {
      // Make the X Ads call here, then report what it returned.
      const id = 'x_ads_8f3a2c';
      return const XAdsCallResult(
          value: id,
          result: XAdsResult(
              accountId: 'account_8f3a2c',
              fundingInstrumentId: 'fundinginstrument_8f3a2c',
              campaignId: 'campaign_8f3a2c',
              lineItemId: 'lineitem_8f3a2c',
              promotedTweetId: 'promotedtweet_8f3a2c',
              objective: 'ENGAGEMENTS',
              productType: 'PROMOTED_TWEETS',
              bidStrategy: 'MAX',
              entityStatus: 'ACTIVE',
              spendMicros: 1,
              currencyCode: 'usd',
              impressions: 1,
              engagements: 1,
              likes: 1,
              retweets: 1,
              replies: 1,
              urlClicks: 1,
              appClicks: 1,
              statusCode: 201));
    },
  );
  OTelLog.info('tracedXAds campaigns.create returned $xAdsId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutXAdsInstrumentationAsync.
  await runWithoutXAdsInstrumentationAsync(
    () => tracedXAds<String>(
      operation: 'campaigns.create',
      invoke: () async {
        const id = 'x_ads_8f3a2c';
        return const XAdsCallResult(
            value: id,
            result: XAdsResult(
                accountId: 'account_8f3a2c',
                fundingInstrumentId: 'fundinginstrument_8f3a2c',
                campaignId: 'campaign_8f3a2c',
                lineItemId: 'lineitem_8f3a2c',
                promotedTweetId: 'promotedtweet_8f3a2c',
                objective: 'ENGAGEMENTS',
                productType: 'PROMOTED_TWEETS',
                bidStrategy: 'MAX',
                entityStatus: 'ACTIVE',
                spendMicros: 1,
                currencyCode: 'usd',
                impressions: 1,
                engagements: 1,
                likes: 1,
                retweets: 1,
                replies: 1,
                urlClicks: 1,
                appClicks: 1,
                statusCode: 201));
      },
    ),
  );

  await OTel.shutdown();
}
