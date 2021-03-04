import 'package:flutter/material.dart';
import 'package:meet_ceylon/model/user.dart';
import 'package:meet_ceylon/provider/position_feedback_provider.dart';
import 'package:provider/provider.dart';


class UserCardWidget extends StatefulWidget {
  final List<String> photoAssetPaths;
  final int visiblePhotoIndex;
  final User user;
  final bool isUserInFocus;

  const UserCardWidget({
    @required this.photoAssetPaths,
    @required this.visiblePhotoIndex,
    @required this.user,
    @required this.isUserInFocus,
    Key key,
  }) : super(key: key);

  @override
  _UserCardWidgetState createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  int visiblePhotoIndex;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
  }

  @override
  void didUpdateWidget(UserCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visiblePhotoIndex != oldWidget.visiblePhotoIndex) {
      setState(() {
        visiblePhotoIndex = widget.visiblePhotoIndex;
      });
    }
  }

  void _prevImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex > 0 ? visiblePhotoIndex - 1 : 0;
    });
  }

  void _nextImage() {
     setState(() {
       print("next");
      visiblePhotoIndex = visiblePhotoIndex < widget.photoAssetPaths.length - 1
          ? visiblePhotoIndex + 1
          : visiblePhotoIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackPositionProvider>(context);
    final swipingDirection = provider.swipingDirection;
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: size.width * 0.90,
        height: size.height * 0.55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(widget.photoAssetPaths[visiblePhotoIndex]),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            new Positioned.fill(
                child: new Material(
                    color: Colors.transparent,
                    child: new InkWell(
                      onTap: () => _nextImage(),
                    ),),),
            Positioned(
              right: 10,
              left: 10,
              bottom: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildUserInfo(user: widget.user),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16, right: 8),
                    child: Icon(Icons.info, color: Colors.white),
                  )
                ],
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: SelectedPhotoIndicator(
                photoCount: widget.photoAssetPaths.length,
                visiblePhotoIndex: visiblePhotoIndex,
              ),
            ),
            if (widget.isUserInFocus) buildLikeBadge(swipingDirection)
          ],
        ),
      ),
    );
  }

  Widget buildLikeBadge(SwipingDirection swipingDirection) {
    final isSwipingRight = swipingDirection == SwipingDirection.right;
    final color = isSwipingRight ? Colors.green : Colors.pink;
    final angle = isSwipingRight ? -0.5 : 0.5;

    if (swipingDirection == SwipingDirection.none) {
      return Container();
    } else {
      return Positioned(
        top: 20,
        right: isSwipingRight ? null : 20,
        left: isSwipingRight ? 20 : null,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 2),
            ),
            child: Text(
              isSwipingRight ? 'LIKE' : 'NOPE',
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildUserInfo({@required User user}) => Padding(
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${user.name}, ${user.age}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8),
        Text(
          user.designation,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(
          '${user.mutualFriends} Mutual Friends',
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
  );
}


class SelectedPhotoIndicator extends StatelessWidget {
  final int photoCount;
  final int visiblePhotoIndex;

  SelectedPhotoIndicator({this.visiblePhotoIndex, this.photoCount});

  Widget _buildInactiveIndicator() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 2.0, right: 2.0),
        child: Container(
          height: 3.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveIndicator() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: Container(
          height: 3.0,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(2.5),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x22000000),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: const Offset(0.0, 1.0))
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < photoCount; i++) {
      indicators.add(i == visiblePhotoIndex
          ? _buildActiveIndicator()
          : _buildInactiveIndicator());
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Row(
        children: _buildIndicators(),
      ),
    );
  }
}
