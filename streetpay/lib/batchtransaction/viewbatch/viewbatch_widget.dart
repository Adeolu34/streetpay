import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/batch_payout_service.dart';
import '/batchtransaction/batchsingle/batchsingle_widget.dart';
import 'viewbatch_model.dart';
export 'viewbatch_model.dart';

class ViewbatchWidget extends StatefulWidget {
  const ViewbatchWidget({super.key});

  static String routeName = 'viewbatch';
  static String routePath = '/viewbatch';

  @override
  State<ViewbatchWidget> createState() => _ViewbatchWidgetState();
}

class _ViewbatchWidgetState extends State<ViewbatchWidget> {
  late ViewbatchModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<BatchGroup> _batches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ViewbatchModel());
    _loadBatches();
  }

  Future<void> _loadBatches() async {
    setState(() => _isLoading = true);
    final list = await BatchPayoutService.getBatches(forceRefresh: true);
    if (mounted) {
      setState(() {
        _batches = list;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _showCreateBatchSheet() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 28.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0D7D2),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF7EE),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Icon(
                        Icons.create_new_folder_outlined,
                        color: Color(0xFF2F8F3C),
                        size: 22.0,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Payout Batch',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF0B2018),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'e.g. Staff Salaries, Market Suppliers, Branch Team',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6B7F72),
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  'BATCH NAME',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF8FA596),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF0B2018),
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Staff Wages',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF9AA79E),
                      fontSize: 14.0,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF6F8F6),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 14.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF2F8F3C), width: 1.5),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Please enter a batch name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  'DESCRIPTION (OPTIONAL)',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF8FA596),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: descController,
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF0B2018),
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Monthly stipend for Ikeja branch staff',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF9AA79E),
                      fontSize: 13.5,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF6F8F6),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(color: Color(0xFFE6EAE7)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.0),
                      borderSide: const BorderSide(
                          color: Color(0xFF2F8F3C), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      Navigator.pop(ctx);
                      final newBatch = await BatchPayoutService.createBatch(
                        name: nameController.text.trim(),
                        description: descController.text.trim(),
                      );
                      await _loadBatches();

                      // Directly navigate into the new batch to start adding members
                      if (mounted) {
                        context.pushNamed(
                          BatchsingleWidget.routeName,
                          queryParameters: {
                            'batchId': serializeParam(
                              newBatch.id,
                              ParamType.String,
                            ),
                          }.withoutNulls,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B2018),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: Color(0xFF56B84B),
                          size: 18.0,
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Create Batch & Add Members',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDeleteBatch(BatchGroup batch) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFDC2626),
                size: 20.0,
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                'Delete Batch?',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF0B2018),
                  fontSize: 17.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${batch.name}"? All ${batch.beneficiaryCount} saved beneficiaries in this batch will be removed.',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF6B7F72),
            fontSize: 13.5,
            height: 1.4,
          ),
        ),
        actionsPadding:
            const EdgeInsets.only(right: 16.0, bottom: 16.0, top: 4.0),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
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
              'Delete',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await BatchPayoutService.deleteBatch(batch.id);
      await _loadBatches();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Batch "${batch.name}" deleted',
              style: GoogleFonts.plusJakartaSans(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF0B2018),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFF6F8F6),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B2018),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 22.0,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Batch & Bulk Payouts',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 22.0,
              ),
              onPressed: _loadBatches,
              tooltip: 'Refresh batches',
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showCreateBatchSheet,
          backgroundColor: const Color(0xFF0B2018),
          elevation: 4.0,
          icon: const Icon(Icons.add_rounded, color: Color(0xFF56B84B)),
          label: Text(
            'New Batch',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14.0,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: RefreshIndicator(
            onRefresh: _loadBatches,
            color: const Color(0xFF2F8F3C),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 96.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero informational card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0B2018), Color(0xFF163C2E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF0B2018).withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF56B84B)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Icon(
                                Icons.hub_outlined,
                                color: Color(0xFF56B84B),
                                size: 20.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'BULK PAYOUT WORKSPACE',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF56B84B),
                                fontSize: 11.0,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          'Disburse Payroll & Multi-Pay',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Organize staff wages, contractor stipends, and vendor disbursements into reusable lists for 1-tap payouts anytime.',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFC4D5C9),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        InkWell(
                          onTap: _showCreateBatchSheet,
                          borderRadius: BorderRadius.circular(12.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: Color(0xFF56B84B),
                                  size: 16.0,
                                ),
                                const SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    'Create New Payout Batch',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6.0),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 14.0,
                                ),
                              ],
                            ),
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
                        'SAVED BATCHES (${_batches.length})'.toUpperCase(),
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2F8F3C)),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12.0),

                  // Batches List / Empty State
                  if (!_isLoading && _batches.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: const Color(0xFFE6EAE7)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64.0,
                            height: 64.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDF7EE),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.playlist_add_check_rounded,
                              color: Color(0xFF2F8F3C),
                              size: 32.0,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'No Payout Batches Yet',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF0B2018),
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          Text(
                            'Create your first batch (e.g. "Staff Wages") to save your recipients, assign their amounts, and disburse together.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF6B7F72),
                              fontSize: 13.0,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          ElevatedButton.icon(
                            onPressed: _showCreateBatchSheet,
                            icon: const Icon(Icons.add_rounded, size: 18.0),
                            label: const Text('Create Batch'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0B2018),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _batches.length,
                      itemBuilder: (context, index) {
                        final batch = _batches[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.0),
                            border:
                                Border.all(color: const Color(0xFFE6EAE7)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () async {
                              await context.pushNamed(
                                BatchsingleWidget.routeName,
                                queryParameters: {
                                  'batchId': serializeParam(
                                    batch.id,
                                    ParamType.String,
                                  ),
                                }.withoutNulls,
                              );
                              _loadBatches();
                            },
                            borderRadius: BorderRadius.circular(18.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 44.0,
                                        height: 44.0,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEDF7EE),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: const Icon(
                                          Icons.folder_shared_rounded,
                                          color: Color(0xFF2F8F3C),
                                          size: 22.0,
                                        ),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              batch.name,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                color: const Color(0xFF0B2018),
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            if (batch.description.isNotEmpty) ...[
                                              const SizedBox(height: 2.0),
                                              Text(
                                                batch.description,
                                                style: GoogleFonts
                                                    .plusJakartaSans(
                                                  color:
                                                      const Color(0xFF6B7F72),
                                                  fontSize: 12.0,
                                                ),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.more_vert_rounded,
                                          color: Color(0xFF8FA596),
                                          size: 20.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        onSelected: (val) {
                                          if (val == 'delete') {
                                            _confirmDeleteBatch(batch);
                                          }
                                        },
                                        itemBuilder: (ctx) => [
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .delete_outline_rounded,
                                                  color: Color(0xFFDC2626),
                                                  size: 18.0,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  'Delete Batch',
                                                  style: TextStyle(
                                                    color: Color(0xFFDC2626),
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14.0),
                                  const Divider(
                                    height: 1.0,
                                    color: Color(0xFFF0F4F1),
                                  ),
                                  const SizedBox(height: 12.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        spacing: 8.0,
                                        runSpacing: 4.0,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF6F8F6),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  color: const Color(
                                                      0xFFE6EAE7)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.people_outline_rounded,
                                                  size: 14.0,
                                                  color: Color(0xFF2F8F3C),
                                                ),
                                                const SizedBox(width: 4.0),
                                                Text(
                                                  '${batch.beneficiaryCount} ${batch.beneficiaryCount == 1 ? "Person" : "People"}',
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontSize: 11.5,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color:
                                                        const Color(0xFF2B3630),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEDF7EE),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              formatNumber(
                                                batch.totalAmount,
                                                formatType: FormatType.decimal,
                                                decimalType: DecimalType
                                                    .periodDecimal,
                                                currency: '₦',
                                              ),
                                              style: GoogleFonts
                                                  .plusJakartaSans(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    const Color(0xFF2F8F3C),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Manage',
                                            style: GoogleFonts
                                                .plusJakartaSans(
                                              color: const Color(0xFF0B2018),
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12.0,
                                            color: Color(0xFF0B2018),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
