NewRelic-RabbitMQ-Plugin Changelog
=========================
This file is used to list changes made in each version of the `newrelic-rmq-plugin` gem.

v0.1.8 (2017-04-25)
-------------------
- Remove erroneous dependencies

v0.1.7 (2017-03-17)
-------------------
- Add ability to detect cluster issues

v0.1.6 (2016-11-28)
-------------------
- Break Queue Size Totals out so that we can use the 'Stacked Area' Chart Type
- Strip out configuration reporting metrics for RabbitMQ & Erlang version.  They might contain non-numeric values.
- Clean up & consolidate rate_for definition

v0.1.5 (2016-11-12)
-------------------
- Revert

v0.1.4 (2016-11-12)
-------------------
- Swap Queue Size to a Count Metric

v0.1.3 (2016-11-10)
-------------------
- Increase efficiency of polling

v0.1.2 (2016-11-10)
-------------------
- Attempt to fix Metric Value names

v0.1.1 (2016-11-10)
-------------------
- Remove `cluster_name` metric since only integers are supported

v0.1.0 (2016-11-10)
-------------------
- Initial Release