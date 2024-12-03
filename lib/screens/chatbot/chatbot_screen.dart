import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:ict_hackthon_no_attitude/services/chatbot_service.dart';
import 'package:ict_hackthon_no_attitude/shared/models/chatbot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/constants/colors.dart';
import '../../shared/constants/font_sizes.dart';
import '../../theme/app_theme.dart';
import 'component/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  late SharedPreferences prefs;

  List<String> chatbotHistory = [];
  List<ChatbotData> places = [];

  bool _initialScrollComplete = false;

  Future<void> loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();

    final savedSize = prefs.getInt('fontSize') ?? FontSize.medium.index;
    if (mounted && savedSize < FontSize.values.length) {
      setState(() {
        fontSize = FontSize.values[savedSize];
      });
    }
  }

  Future<void> getInitState() async {
    isLoading = true;
    prefs = await SharedPreferences.getInstance();

    final savedSize = prefs.getInt('fontSize') ?? FontSize.medium.index;
    fontSize = FontSize.values[savedSize];

    chatbotHistory = await prefs.getStringList('chatbotHistory') ?? [];
    if (mounted) {
      setState(() {
        // chatbotHistory = [];

        if (chatbotHistory.isEmpty) {
          chatbotHistory.add('''안녕하세요! 저는 양양의 모든 것을 알고 있는 여행 가이드 '해키'입니다! 🌊 
양양의 멋진 바다와 맛있는 먹거리, 숨은 명소들까지 제가 다 알려드릴게요!!\n
특히 좋아하는 여행 스타일을 알려주시면 제가 스타일에 맞는 여행지 경로를 추천해 줄 거예요. \n
궁금한 점이 있으시다면 편하게 물어보세요! \n양양 여행이 더 즐거워지도록 도와드릴게요! 😊''');
        }

        isLoading = false;
      });
    }
  }

  FontSize fontSize = FontSize.medium;

  @override
  void initState() {
    super.initState();
    getInitState();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients && !_initialScrollComplete) {
      _initialScrollComplete = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage(String value) async {
    if (value.isEmpty) return;

    setState(() {
      isLoading = true;
      chatbotHistory.add(value);
      _textController.clear();
    });

    try {
      String response = '''사용자 특성에 맞게 여행지를 추천해드릴게요!
코스1
장소의 이름: 영광정메밀국수 본점
설명: 30여년 전 할머니께서 동리사람들을 상대로 막국수를 만들어 팔면서 시작하여 현재는 3대가 함께 가게를 운영하고 있으며, 순지방 메밀만 사용하여 메밀 특유의 독특한 향과 맛을 연출하여 한 번 온 사람들은 꼭 다시 찾는다. 특히 자연경관이 수려한 설악산자락에 위치하고 있으며 사시사철 살얼음이 뜨는 동치미는 막국수의 시원하고구수한 맛을 한층 돋군다.

코스2
장소의 이름: 낙산사
설명: 낙산사는 강원특별자치도 양양군을 대표하는 관광명소이자 역사적 가치가 큰 명승지다. 신라 문무왕 11년(671)에 의상대사가 창건한 고찰로 강화 보문사, 남해 보리암과 더불어 한국 3대 관음성지로 꼽힌다. 동해가 한눈에 내려다보이는 천혜의 풍광이 아름다운 사찰은 관동팔경(강원특별자치도 영동의 여덟 군데 명승지) 중 한 곳으로, 예로부터 수많은 고전과 시문에 그 아름다움이 전해지고 있다.

코스3
장소의 이름: 하조대
설명: 하조대는 양양10경 중 하나이다. 135,000㎡에 이르는 암석해안은 짙푸른 동해에 솟은 기암괴석과 바위섬으로 이루어져 있고, 주변 송림과 어우러져 경관이 빼어나다. 데크길을 따라 올라가면 정자가 자리하고 있다. 하조대는 1955년에 건립되었으며, 2009년에 명승 제68호로 지정되었다. 6.25 전쟁으로 불타 소실된 것을 다시 복원한 것이다. 정자 안쪽으로는 하조대 현판이 걸려있다. 조선의 개국공신인 하륜과 조준이 고려 말, 이곳에서 은둔하며 혁명을 도모하여 두 사람의 성을 따 ‘하조대’라는 이름을 지었다고 전해진다.

코스4
장소의 이름: 쏠비치 양양
설명: 동해와 설악의 청정 자연을 누리며 스페인에 온 듯 이국적인 분위기를 즐길 수 있는 해양 리조트다. 쏠비치 호텔 양양&리조트의 특징은 스페인의 건축 미학을 충실히 반영했다는 점이다. 스페인 남부 안달루시아의 말라가 항구 ‘태양의 해변(Costa del Sol)’ 지역을 모티프로 한 건물은 붉은 지붕과 흰 외벽, 넓은 창가와 테라스로 눈길을 사로잡는다.

코스5
장소의 이름: 금강산대게횟집
설명: 금강산대게횟집은 아름다운 낙산해수욕장을 바라보며 여유롭게 즐길 수 있는 해산물 식당이에요. 다양한 해물탕, 반찬, 메인 메뉴를 만나볼 수 있죠. 대표적인 메뉴로는 회, 곰치국, 킹크랩, 홍게라면 등이 있어요.

코스6
장소의 이름: 쏠티캐빈 양양점
설명: 서핑하는 사람들의 성지로 불리는 곳이다. 그 이름의 의미는 서퍼들의 영혼을 나타내는 단어인 ‘쏠티 SALTY’와 자연 속 오두막을 의미하는 단어인 ‘캐빈 CABIN’이 결합된 단어로 서퍼들의 영혼이 쉬어갈 수 있는 오두막이라는 의미를 담고 있다. 쏠티 캐빈의 1층은 웨트 슈트를 비롯한 해양스포츠를 즐기는데 필요한 의류와 장비 등을 전시 판매하는 공간과 카페가 있다.

우측 하단에 지도 아이콘을 눌러 지도를 활성화하세요!
''';

      Future.delayed(const Duration(seconds: 2), () {
        chatbotHistory.add(response);
        prefs.setStringList('chatbotHistory', chatbotHistory);
      });

      _focusNode.requestFocus();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('메시지 전송에 실패했습니다.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollToBottom();
    return Column(
      children: [
        SizedBox(
          height: 150,
        ),
        Expanded(
            child: ListView.builder(
          key: PageStorageKey('chat_list'),
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: chatbotHistory.length,
          itemBuilder: (context, index) {
            final isUserMessage = index % 2 == 1;
            return ChatBubble(
                isUserMessage: isUserMessage,
                chatbotHistory: chatbotHistory,
                index: index,
                fontSize: fontSize);
          },
        )),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: MediaQuery.of(context).viewPadding.bottom + 8,
          ),
          child: Column(
            children: [
              if (isLoading)
                const LinearProgressIndicator(
                  backgroundColor: Color(0xFFE0E0E0),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        enabled: !isLoading,
                        style: TextStyle(
                          fontSize: AppFontSize.chatFontSize[fontSize],
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: '메시지를 입력하세요',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: AppFontSize.chatFontSize[fontSize],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        onSubmitted: (value) {
                          if (!isLoading) {
                            _sendMessage(value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      onPressed: isLoading
                          ? null
                          : () => _sendMessage(_textController.text),
                      icon: Icon(
                        isLoading ? Icons.hourglass_empty : Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
