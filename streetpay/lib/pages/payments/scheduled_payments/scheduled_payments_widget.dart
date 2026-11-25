import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/scheduled_payment_service.dart';

class ScheduledPaymentsWidget extends StatefulWidget {
  const ScheduledPaymentsWidget({super.key});

  static String routeName = 'ScheduledPayments';
  static String routePath = '/scheduledPayments';

  @override
  State<ScheduledPaymentsWidget> createState() => _ScheduledPaymentsWidgetState();
}

class _ScheduledPaymentsWidgetState extends State<ScheduledPaymentsWidget> {
  List<ScheduledPaymentItem> _schedules = [];
  bool _isLoading = true;
  Timer? _countdownTicker;

  @override
  void initState() {
    super.initState();
    _loadSchedules();

    // Active in-screen ticker to update countdowns and execute immediately when the clock strikes
    _countdownTicker = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!mounted) return;
      final anyDue = _schedules.any((s) => s.isDue);
      if (anyDue) {
        await ScheduledPaymentService.executeDueSchedules();
        final list = await ScheduledPaymentService.getAllSchedules();
        if (mounted) {
          setState(() {
            _schedules = list;
          });
        }
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _countdownTicker?.cancel();
    super.dispose();
  }

  Future<void> _loadSchedules() async {
    setState(() => _isLoading = true);
    await ScheduledPaymentService.executeDueSchedules();
    final list = await ScheduledPaymentService.getAllSchedules();
    if (mounted) {
      setState(() {
        _schedules = list;
        _isLoading = false;
      });
    }
  }

  String _formatCountdown(DateTime scheduledTime) {
    final now = DateTime.now();
    final difference = scheduledTime.difference(now);

    if (difference.isNegative) {
      return 'Matured / Due';
    } else if (difference.inDays > 0) {
      return 'Due in ${difference.inDays}d ${difference.inHours % 24}h';
    } else if (difference.inHours > 0) {
      return 'Due in ${difference.inHours}h ${difference.inMinutes % 60}m';
    } else if (difference.inMinutes > 0) {
      return 'Due in ${difference.inMinutes} mins';
    } else {
      return 'Due momentarily';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return const Color(0xFF2F8F3C);
      case 'PENDING':
        return const Color(0xFFE65100);
      case 'FAILED':
        return const Color(0xFFDC2626);
      case 'CANCELLED':
      default:
        return const Color(0xFF8FA596);
    }
  }

  Color _getStatusBg(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return const Color(0xFFEDF7EE);
      case 'PENDING':
        return const Color(0xFFFFF3E0);
      case 'FAILED':
        return const Color(0xFFFEE2E2);
      case 'CANCELLED':
      default:
        return const Color(0xFFF1F5F2);
    }
  }

  Future<void> _confirmCancel(ScheduledPaymentItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text(
          'Cancel Schedule?',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF0B2018),
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel the scheduled payment of ₦${formatNumber(item.amount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} to ${item.recipientName}?',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF6B7F72),
            fontSize: 14.0,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Keep Schedule',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF6B7F72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              'Cancel Payment',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ScheduledPaymentService.cancelSchedule(item.id);
      _loadSchedules();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Schedule cancelled. ₦${formatNumber(item.amount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} returned to your available balance.',
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            backgroundColor: const Color(0xFF0B2018),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingSchedules = _schedules.where((s) => s.status == 'PENDING').toList();
    final double totalPendingAmount =
        pendingSchedules.fold(0.0, (acc, item) => acc + item.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2018),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Scheduled Payments',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _loadSchedules,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadSchedules,
          color: const Color(0xFF2F8F3C),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Summary Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0B2018), Color(0xFF163C2E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0B2018).withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF56B84B).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.alarm_on_rounded, color: Color(0xFF56B84B), size: 14.0),
                                const SizedBox(width: 4.0),
                                Text(
                                  'AUTOMATED SCHEDULER',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFF7FD472),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${pendingSchedules.length} Active',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFCFE3D6),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14.0),
                      Text(
                        'Total Earmarked (On Hold)',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF8FA596),
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        '₦${formatNumber(totalPendingAmount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Reserved funds remain in your ledger balance but are deducted from available spendable balance until sent or cancelled.',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFFCFE3D6),
                          fontSize: 12.0,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24.0),

                // Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'UPCOMING & PAST SCHEDULES (${_schedules.length})'.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF8FA596),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    if (_isLoading)
                      const SizedBox(
                        width: 14.0,
                        height: 14.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F8F3C)),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12.0),

                // Schedule List / Empty State
                if (!_isLoading && _schedules.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(36.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: const Color(0xFFE6EAE7)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEDF7EE),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.schedule_rounded,
                            color: Color(0xFF2F8F3C),
                            size: 28.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'No Scheduled Payments',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF0B2018),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          'When sending money or disbursing payroll, select "Schedule for Later" to set up automatic future transfers.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF6B7F72),
                            fontSize: 13.0,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _schedules.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                    itemBuilder: (context, index) {
                      final item = _schedules[index];
                      final isPending = item.status == 'PENDING';

                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                          border: Border.all(color: const Color(0xFFE6EAE7)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: item.isBatch
                                        ? const Color(0xFFEDF7EE)
                                        : const Color(0xFFF3F6F3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    item.isBatch
                                        ? Icons.hub_rounded
                                        : Icons.north_east_rounded,
                                    color: const Color(0xFF2F8F3C),
                                    size: 20.0,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.recipientName,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF0B2018),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        item.isBatch
                                            ? 'Bulk Payout Group'
                                            : '${item.accountNumber} · ${item.bankName}',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFF6B7F72),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₦${formatNumber(item.amount, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)}',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF0B2018),
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                      decoration: BoxDecoration(
                                        color: _getStatusBg(item.status),
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      child: Text(
                                        item.status,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: _getStatusColor(item.status),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (item.status == 'FAILED' &&
                                item.failureReason != null &&
                                item.failureReason!.isNotEmpty) ...[
                              const SizedBox(height: 10.0),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: const Color(0xFFFECACA)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline_rounded,
                                        size: 14.0, color: Color(0xFFDC2626)),
                                    const SizedBox(width: 6.0),
                                    Expanded(
                                      child: Text(
                                        item.failureReason!,
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFDC2626),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const Divider(height: 20.0, color: Color(0xFFF1F5F2)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded, size: 14.0, color: Color(0xFF8FA596)),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      DateFormat('MMM d, y · h:mm a').format(item.scheduledTime),
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFF6B7F72),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (isPending) ...[
                                      const SizedBox(width: 6.0),
                                      Text(
                                        '(${_formatCountdown(item.scheduledTime)})',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFE65100),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (isPending)
                                  InkWell(
                                    onTap: () => _confirmCancel(item),
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFDC2626),
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
