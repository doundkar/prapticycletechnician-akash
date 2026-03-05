import 'package:flutter/material.dart';
import 'package:bicycle_app_technician/view/widgets/custom_app_bar.dart';
import 'package:bicycle_app_technician/view/Colors/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Help & Support"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Intro Text
            const Text(
              "We're here to help you with jobs, payments, and app issues.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// CALL SUPPORT CARD
            _cardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.call_outlined),
                      SizedBox(width: 8),
                      Text(
                        "Call Support",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(height: 20),
                  Text("Talk to our support team"),
                  SizedBox(height: 4),
                  Text("Available: 9:00 AM - 9:00 PM",
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 10),
                  Text(
                    "Call: +91 99887 76655",
                    style: TextStyle(
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// CHAT SUPPORT CARD
            _cardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.chat_bubble_outline),
                      SizedBox(width: 8),
                      Text(
                        "Chat Support",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "Instant help via chat for job issues, delays, app problems",
                          style: TextStyle(
                              color: Colors.grey),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          elevation: 0,
                        ),
                        child: const Text("Start Chat"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// EMAIL SUPPORT CARD
            _cardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.email_outlined),
                      SizedBox(width: 8),
                      Text(
                        "Email Support",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  const Text("Support@technicianapp.com"),
                  const SizedBox(height: 4),
                  const Text("Response within 24 hours",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search help topics...",
                      prefixIcon:
                          const Icon(Icons.search),
                      filled: true,
                      fillColor:
                          Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// FAQ SECTIONS
            _faqSection(
              title: "Job & Services Issues",
              items: [
                "Unable to accept job",
                "Customer not reachable",
                "Job cancelled by customer",
                "Extra work request"
              ],
            ),

            const SizedBox(height: 16),

            _faqSection(
              title: "Payment & Earnings",
              items: [
                "Payment not received",
                "Wallet balance mismatch",
                "Withdrawal issues",
                "Commission queries"
              ],
            ),

            const SizedBox(height: 16),

            _faqSection(
              title: "Location & Availability",
              items: [
                "App not detecting location",
                "Unable to add work area",
                "Online/Offline not updation"
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Reusable Card Container
  Widget _cardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  /// FAQ Section
  Widget _faqSection({
    required String title,
    required List<String> items,
  }) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w600),
          ),
          const Divider(height: 20),
          ...items.map((item) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    )
                  ],
                ),
                const SizedBox(height: 12),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}