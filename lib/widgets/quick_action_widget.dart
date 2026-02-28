import 'package:flutter/material.dart';
import 'package:retail_smb/widgets/dashboard_card_container.dart';
import 'package:retail_smb/theme/color_schema.dart';

enum DashboardWidgetVariant {
  quickAction,
  businessHealth,
  prioritazionAction,
  stockOverview,
  weeklySales,
}

class QuickActionMenuItem {
  final String title;
  final String assetPath;
  final VoidCallback onTap;

  const QuickActionMenuItem({
    required this.title,
    required this.assetPath,
    required this.onTap,
  });
}

class BusinessHealthItem {
  final String prefixText;
  final String highlightedText;
  final String suffixText;
  final Color markerColor;

  const BusinessHealthItem({
    required this.prefixText,
    required this.highlightedText,
    this.suffixText = '',
    required this.markerColor,
  });
}

class PrioritazionActionData {
  final String itemName;
  final String actionText;
  final String dateText;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;
  final String primaryLabel;
  final String secondaryLabel;

  const PrioritazionActionData({
    required this.itemName,
    required this.actionText,
    required this.dateText,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
    this.primaryLabel = 'Snooze',
    this.secondaryLabel = 'Chat',
  });
}

class OverviewRowData {
  final String item;
  final String value;
  final String status;
  final Color statusColor;

  const OverviewRowData({
    required this.item,
    required this.value,
    required this.status,
    required this.statusColor,
  });
}

class DashboardSectionWidget extends StatelessWidget {
  final DashboardWidgetVariant variant;
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;
  final List<QuickActionMenuItem> quickActions;
  final List<BusinessHealthItem> businessHealthItems;
  final PrioritazionActionData? prioritazionAction;
  final List<OverviewRowData> overviewRows;

  const DashboardSectionWidget.quickAction({
    super.key,
    required this.quickActions,
    this.title = 'Quick Action',
    this.showSeeAll = false,
    this.onSeeAllTap,
  }) : variant = DashboardWidgetVariant.quickAction,
       businessHealthItems = const [],
       prioritazionAction = null,
       overviewRows = const [];

  const DashboardSectionWidget.businessHealth({
    super.key,
    required this.businessHealthItems,
    this.title = 'Business Health',
    this.showSeeAll = false,
    this.onSeeAllTap,
  }) : variant = DashboardWidgetVariant.businessHealth,
       quickActions = const [],
       prioritazionAction = null,
       overviewRows = const [];

  const DashboardSectionWidget.prioritazionAction({
    super.key,
    required this.prioritazionAction,
    this.title = 'Prioritazion Action',
    this.showSeeAll = true,
    this.onSeeAllTap,
  }) : variant = DashboardWidgetVariant.prioritazionAction,
       quickActions = const [],
       businessHealthItems = const [],
       overviewRows = const [];

  const DashboardSectionWidget.stockOverview({
    super.key,
    required this.overviewRows,
    this.title = 'Stock Overview',
    this.showSeeAll = true,
    this.onSeeAllTap,
  }) : variant = DashboardWidgetVariant.stockOverview,
       quickActions = const [],
       businessHealthItems = const [],
       prioritazionAction = null;

  const DashboardSectionWidget.weeklySales({
    super.key,
    required this.overviewRows,
    this.title = 'Weekly Sales',
    this.showSeeAll = true,
    this.onSeeAllTap,
  }) : variant = DashboardWidgetVariant.weeklySales,
       quickActions = const [],
       businessHealthItems = const [],
       prioritazionAction = null;

  @override
  Widget build(BuildContext context) {
    return DashboardCardContainer(
      title: title,
      showSeeAll: showSeeAll,
      onSeeAllTap: onSeeAllTap,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (variant) {
      case DashboardWidgetVariant.quickAction:
        return _QuickActionContent(items: quickActions);
      case DashboardWidgetVariant.businessHealth:
        return _BusinessHealthContent(items: businessHealthItems);
      case DashboardWidgetVariant.prioritazionAction:
        if (prioritazionAction == null) {
          return const SizedBox.shrink();
        }
        return _PrioritazionActionContent(data: prioritazionAction!);
      case DashboardWidgetVariant.stockOverview:
      case DashboardWidgetVariant.weeklySales:
        return _OverviewTableContent(rows: overviewRows);
    }
  }
}

class _QuickActionContent extends StatelessWidget {
  final List<QuickActionMenuItem> items;

  const _QuickActionContent({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.primaryBimaLighter),
      ),
      child: Row(
        children: items
            .map(
              (item) => Expanded(
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.neutralWhiteLighter,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.primaryBimaLight),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Image.asset(item.assetPath, fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            color: AppColors.neutralBlackDarker,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BusinessHealthContent extends StatelessWidget {
  final List<BusinessHealthItem> items;

  const _BusinessHealthContent({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.primaryBimaLighter),
      ),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: item.markerColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: item.prefixText),
                            TextSpan(
                              text: item.highlightedText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryBimaDark,
                              ),
                            ),
                            TextSpan(text: item.suffixText),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PrioritazionActionContent extends StatelessWidget {
  final PrioritazionActionData data;

  const _PrioritazionActionContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.primaryBimaLighter),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.4,
                color: AppColors.neutralBlackLighter,
              ),
              children: [
                TextSpan(
                  text: '${data.itemName}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                TextSpan(text: data.actionText),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.dateText,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: AppColors.neutralBlackLighter,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: data.onPrimaryTap,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(56, 32),
                  side: const BorderSide(color: AppColors.primaryBimaBase),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: Text(
                  data.primaryLabel,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryBimaBase,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: data.onSecondaryTap,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(56, 32),
                  backgroundColor: AppColors.primaryBimaBase,
                  foregroundColor: AppColors.neutralWhiteLighter,
                  shadowColor: const Color(0x0D101828),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: Text(
                  data.secondaryLabel,
                  style: const TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewTableContent extends StatelessWidget {
  final List<OverviewRowData> rows;

  const _OverviewTableContent({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 34,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.brand25,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'Item',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xCC000000),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Stock Level',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xCC000000),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Status',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xCC000000),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...rows.map(
          (row) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    row.item,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: Color(0xCC000000),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    row.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: Color(0xCC000000),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: row.statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          row.status,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            color: AppColors.primaryBimaDarker,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
