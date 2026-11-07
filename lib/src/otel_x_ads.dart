// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_x_ads_suppression.dart';

const _tracerName = 'dartastic_otel_libs_x_ads';

APITracer _tracer() => OTelAPI.tracerProvider().getTracer(_tracerName);

class XAdsResult {
  /// Creates a result.
  const XAdsResult({
    this.accountId,
    this.fundingInstrumentId,
    this.campaignId,
    this.lineItemId,
    this.promotedTweetId,
    this.objective,
    this.productType,
    this.bidStrategy,
    this.entityStatus,
    this.spendMicros,
    this.currencyCode,
    this.impressions,
    this.engagements,
    this.likes,
    this.retweets,
    this.replies,
    this.urlClicks,
    this.appClicks,
    this.statusCode,
  });

  final String? accountId;

  /// Credit line / funding source used for billing.
  final String? fundingInstrumentId;

  final String? campaignId;

  /// X's term for "ad group".
  final String? lineItemId;

  final String? promotedTweetId;

  /// `ENGAGEMENTS` / `REACH` / `WEBSITE_CLICKS` / `VIDEO_VIEWS` /
  /// `PREROLL_VIEWS` / `APP_INSTALLS` / `APP_ENGAGEMENTS` /
  /// `FOLLOWERS`.
  final String? objective;

  /// `PROMOTED_TWEETS` / `PROMOTED_ACCOUNT` / `MEDIA_FORWARDS` etc.
  final String? productType;

  /// `MAX` / `TARGET` / `AUTO`.
  final String? bidStrategy;

  /// `ACTIVE` / `PAUSED` / `DELETED` / `DRAFT`.
  final String? entityStatus;

  /// Spend in micros (X uses the same convention as Google Ads).
  final int? spendMicros;

  final String? currencyCode;
  final int? impressions;
  final int? engagements;
  final int? likes;
  final int? retweets;
  final int? replies;
  final int? urlClicks;
  final int? appClicks;
  final int? statusCode;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class XAdsCallResult<T> {
  /// Creates a call result.
  const XAdsCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final XAdsResult? result;
}

/// Wraps an X Ads API call in a CLIENT span. [operation] is one of
/// `stats.accounts`, `campaigns.create`, `line_items.create`,
/// `promoted_tweets.create`, `audiences.create`,
/// `media_creatives.upload`, `tailored_audiences.user_list`.
Future<T> tracedXAds<T>({
  required String operation,
  required Future<XAdsCallResult<T>> Function() invoke,
}) async {
  if (xAdsInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'x_ads',
    'rpc.method': operation,
    'x_ads.operation': operation,
  };

  final span = _tracer().startSpan(
    'x_ads $operation',
    kind: SpanKind.client,
    attributes: OTelAPI.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final extras = <Attribute<Object>>[];
      if (r.result!.accountId != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.account.id',
          r.result!.accountId!,
        ));
      }
      if (r.result!.fundingInstrumentId != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.funding_instrument.id',
          r.result!.fundingInstrumentId!,
        ));
      }
      if (r.result!.campaignId != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.campaign.id',
          r.result!.campaignId!,
        ));
      }
      if (r.result!.lineItemId != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.line_item.id',
          r.result!.lineItemId!,
        ));
      }
      if (r.result!.promotedTweetId != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.promoted_tweet.id',
          r.result!.promotedTweetId!,
        ));
      }
      if (r.result!.objective != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.objective',
          r.result!.objective!,
        ));
      }
      if (r.result!.productType != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.product.type',
          r.result!.productType!,
        ));
      }
      if (r.result!.bidStrategy != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.bid.strategy',
          r.result!.bidStrategy!,
        ));
      }
      if (r.result!.entityStatus != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.entity.status',
          r.result!.entityStatus!,
        ));
      }
      if (r.result!.spendMicros != null) {
        extras.add(OTelAPI.attributeInt(
          'x_ads.spend.micros',
          r.result!.spendMicros!,
        ));
      }
      if (r.result!.currencyCode != null) {
        extras.add(OTelAPI.attributeString(
          'x_ads.currency.code',
          r.result!.currencyCode!,
        ));
      }
      if (r.result!.impressions != null) {
        extras.add(OTelAPI.attributeInt(
          'x_ads.impressions',
          r.result!.impressions!,
        ));
      }
      if (r.result!.engagements != null) {
        extras.add(OTelAPI.attributeInt(
          'x_ads.engagements',
          r.result!.engagements!,
        ));
      }
      if (r.result!.likes != null) {
        extras.add(OTelAPI.attributeInt('x_ads.likes', r.result!.likes!));
      }
      if (r.result!.retweets != null) {
        extras.add(OTelAPI.attributeInt('x_ads.retweets', r.result!.retweets!));
      }
      if (r.result!.replies != null) {
        extras.add(OTelAPI.attributeInt('x_ads.replies', r.result!.replies!));
      }
      if (r.result!.urlClicks != null) {
        extras.add(OTelAPI.attributeInt(
          'x_ads.url_clicks',
          r.result!.urlClicks!,
        ));
      }
      if (r.result!.appClicks != null) {
        extras.add(OTelAPI.attributeInt(
          'x_ads.app_clicks',
          r.result!.appClicks!,
        ));
      }
      if (r.result!.statusCode != null) {
        extras.add(OTelAPI.attributeInt(
          'http.response.status_code',
          r.result!.statusCode!,
        ));
        if (r.result!.statusCode! >= 400) {
          span.setStatus(
            SpanStatusCode.Error,
            'X Ads HTTP ${r.result!.statusCode}',
          );
        }
      }
      if (extras.isNotEmpty) span.addAttributes(OTelAPI.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTelAPI.attributes([
      OTelAPI.attributeString(
        ErrorAttributes.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
