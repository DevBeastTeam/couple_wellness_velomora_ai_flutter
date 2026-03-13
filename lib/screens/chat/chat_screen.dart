import 'package:velmora/widgets/premium_feature_gate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velmora/constants/app_colors.dart';
import 'package:velmora/l10n/app_localizations.dart';
import 'package:velmora/services/chat_service.dart';
import 'package:velmora/utils/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:velmora/widgets/app_loading_widgets.dart';

class ChatScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const ChatScreen({super.key, this.onBackToHome});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  bool _showDisclaimer = true;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      await _chatService.sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context).translate('failed_to_send_message')}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PremiumFeatureGate(
      featureName: 'AI Chat',
      child: _buildChatContent(context),
    );
  }

  Widget _buildChatContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getChatMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _scrollToBottom();
                }

                Widget? stateWidget;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  stateWidget = const Center(child: AppCircularLoader());
                } else if (snapshot.hasError) {
                  stateWidget = Center(
                    child: Text(
                      '${l10n.translate('error_loading_messages')}: ${snapshot.error}',
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  stateWidget = Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.adaptSize),
                      child: Text(
                        l10n.aiGreeting,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16.fSize,
                        ),
                      ),
                    ),
                  );
                }

                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 180.h,
                      pinned: true,
                      backgroundColor: AppColors.brandPurple,
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          if (widget.onBackToHome != null) {
                            widget.onBackToHome!();
                            return;
                          }
                          Navigator.pop(context);
                        },
                      ),
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        expandedTitleScale: 1.0,
                        titlePadding: EdgeInsets.zero,
                        title: LayoutBuilder(
                          builder: (context, constraints) {
                            final isCollapsed =
                                constraints.maxHeight <=
                                kToolbarHeight +
                                    MediaQuery.of(context).padding.top +
                                    10;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.only(
                                left: isCollapsed ? 0 : 24.w,
                                bottom: isCollapsed ? 16.h : 24.h,
                              ),
                              alignment: isCollapsed
                                  ? Alignment.bottomCenter
                                  : Alignment.bottomLeft,
                              child: isCollapsed
                                  ? Text(
                                      l10n.chat,
                                      style: TextStyle(
                                        fontSize: 18.fSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.chat_bubble_outline,
                                              color: Colors.white,
                                              size: 28.adaptSize,
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(
                                              l10n.chat,
                                              style: TextStyle(
                                                fontSize: 32.fSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          l10n.aiCompanion,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            fontSize: 14.fSize,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                            );
                          },
                        ),
                        background: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.brandPurple,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (stateWidget != null)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: stateWidget,
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final messages = snapshot.data!.docs;
                            final messageData =
                                messages[index].data() as Map<String, dynamic>;
                            final isUser = messageData['isUser'] ?? false;
                            final message = messageData['message'] ?? '';

                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: isUser
                                  ? _buildUserMessage(message)
                                  : _buildAIMessage(message),
                            );
                          }, childCount: snapshot.data!.docs.length),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          _buildChatFooter(),
        ],
      ),
    );
  }

  Widget _buildAIMessage(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Icon Avatar
        Container(
          padding: EdgeInsets.all(8.adaptSize),
          decoration: const BoxDecoration(
            color: AppColors.brandPurpleLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.smart_toy_outlined,
            color: Colors.white,
            size: 20.adaptSize,
          ),
        ),
        SizedBox(width: 12.w),
        // Message Bubble
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.adaptSize),
                bottomLeft: Radius.circular(20.adaptSize),
                bottomRight: Radius.circular(20.adaptSize),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15.fSize,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserMessage(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Message Bubble
        Flexible(
          child: Container(
            padding: EdgeInsets.all(16.adaptSize),
            decoration: BoxDecoration(
              color: AppColors.brandPurple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.adaptSize),
                bottomLeft: Radius.circular(20.adaptSize),
                bottomRight: Radius.circular(20.adaptSize),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.fSize,
                height: 1.4,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // User Icon Avatar
        Container(
          padding: EdgeInsets.all(8.adaptSize),
          decoration: const BoxDecoration(
            color: AppColors.brandPurple,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: Colors.white, size: 20.adaptSize),
        ),
      ],
    );
  }

  Widget _buildChatFooter() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 5.h),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Medical Disclaimer Box
          if (_showDisclaimer)
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.adaptSize),
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6), // Pale Yellow
                    borderRadius: BorderRadius.circular(12.adaptSize),
                    border: Border.all(color: Colors.orange.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.orange,
                        size: 18.adaptSize,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).chatDisclaimer,
                          style: TextStyle(
                            color: Colors.orange.shade900,
                            fontSize: 12.fSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showDisclaimer = false;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.orange.shade300,
                      size: 18.adaptSize,
                    ),
                  ),
                ),
              ],
            ),

          // Text Input Field
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 54.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F9),
                    borderRadius: BorderRadius.circular(15.adaptSize),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).typeMessage,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.fSize,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Send Button
              GestureDetector(
                onTap: _isSending ? null : _sendMessage,
                child: Container(
                  height: 54.h,
                  width: 54.h,
                  decoration: BoxDecoration(
                    color: _isSending
                        ? AppColors.brandPurple.withOpacity(0.5)
                        : AppColors.brandPurple,
                    shape: BoxShape.circle,
                  ),
                  child: _isSending
                      ? Padding(
                          padding: EdgeInsets.all(15.adaptSize),
                          child: const AppCircularLoader(
                            size: 20,
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 24.adaptSize,
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
