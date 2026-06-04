@Component
export struct SessionInfo {
  @Prop completedSessions: number = 0
  @Prop currentSession: number = 0
  private readonly totalDots: number = 4

  build() {
    Column({ space: 6 }) {
      Text('今日专注')
        .fontSize(13)
        .fontColor('#8E8E93')
        .fontWeight(FontWeight.Medium)

      Row({ space: 6 }) {
        ForEach(this.getDots(), (filled: boolean) => {
          Circle({ width: 8, height: 8 })
            .fill(filled ? '#FF6B6B' : '#3A3A3C')
        })
      }
      .justifyContent(FlexAlign.Center)

      Text(`${this.completedSessions} 个番茄已完成`)
        .fontSize(12)
        .fontColor('#636366')
    }
    .alignItems(HorizontalAlign.Center)
  }

  private getDots(): boolean[] {
    const dots: boolean[] = []
    for (let i = 0; i < this.totalDots; i++) {
      dots.push(i < (this.currentSession % this.totalDots))
    }
    return dots
  }
}
