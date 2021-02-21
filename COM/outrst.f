      SUBROUTINE OUTRST(UU,VV,WW,PP,TT,CC,AK,EP,FF,HH,
     $                  VLEND,TMEND,FREND,HDEP,HHBCN,UUBCN,VVBCN,KF,KP)
C======================================================================
C     リスタート出力を行う
C======================================================================
      IMPLICIT NONE
C
      INCLUDE 'DOMAIN.h'
      INCLUDE 'FILE.h'
      INCLUDE 'FILEC.h'
      INCLUDE 'FILEI.h'
      INCLUDE 'MODELI.h'
      INCLUDE 'TIMEI.h'
      INCLUDE 'TIMER.h'
      INCLUDE 'CONNEC.h'
      INCLUDE 'CP_NESTBC.h'
      INCLUDE 'OUTPUT.h'
C
      REAL(8),INTENT(INOUT)::UU(MX,MY,MZ),VV(MX,MY,MZ),WW(MX,MY,MZ)
      REAL(8),INTENT(INOUT)::PP(MX,MY,MZ),TT(MX,MY,MZ),CC(MX,MY,MZ)
      REAL(8),INTENT(INOUT)::AK(MX,MY,MZ),EP(MX,MY,MZ),FF(MX,MY,MZ)
      REAL(8),INTENT(INOUT)::HH(MX,MY)
      REAL(8),INTENT(INOUT)::VLEND(MX,MY,16),TMEND(MX,MY,6)
      REAL(8),INTENT(INOUT)::FREND(MX,MY,2+NFRAGL)
      REAL(8),INTENT(INOUT)::HDEP(MX,MY),HHBCN(MX,MY)
      REAL(8),INTENT(INOUT)::UUBCN(NXY,MZ,4),VVBCN(NXY,MZ,4)
      INTEGER,INTENT(INOUT)::KF(MX,MY),KP(MX,MY)
      INTEGER::IPARNT,I,J,K,LDUM1
C
      IPARNT = IPECON(2,NRANK+1)
      LDUM1=0
C
      WRITE(LP,9510) ISTEP,TIME
      WRITE(IFLRO,ERR=900) ISTEP,TIME,DT,DTOLD,LSURF,LTURB,LTEMP,LCONC,
     $                     LDUM1
      WRITE(IFLRO,ERR=900) UU
      WRITE(IFLRO,ERR=900) VV
      WRITE(IFLRO,ERR=900) WW
      WRITE(IFLRO,ERR=900) PP
      IF( LTEMP.EQ.1 ) WRITE(IFLRO,ERR=900) TT
      IF( LCONC.EQ.1 ) WRITE(IFLRO,ERR=900) CC
C ... LTURB=2(AK=AK,EP=EP),LTURB=3(AK=Q2,EP=QL),LTURB=4(AK=AK)
      IF( LTURB.EQ.2.OR.LTURB.EQ.3 ) WRITE(IFLRO,ERR=900) AK
      IF( LTURB.EQ.2.OR.LTURB.EQ.3 ) WRITE(IFLRO,ERR=900) EP
      IF( LTURB.EQ.4 ) WRITE(IFLRO,ERR=900) AK
      IF( LSURF.EQ.1 ) WRITE(IFLRO,ERR=900) FF
      IF( LSURF.EQ.1 ) WRITE(IFLRO,ERR=900) HH
      IF( LSURF.EQ.1 ) WRITE(IFLRO,ERR=900) KF
      IF( LSURF.EQ.1 ) WRITE(IFLRO,ERR=900) KP
      IF( LSURF.EQ.1 ) THEN
         IF( LSEDI.EQ.1 ) THEN
            WRITE(IFLRO,ERR=900) VLEND
         ELSE
            WRITE(IFLRO,ERR=900) (((VLEND(I,J,K),I=1,MX),J=1,MY),K=1,11)
         ENDIF
      ENDIF
      IF( LSURF.EQ.1 ) WRITE(IFLRO,ERR=900) TMEND
      IF( LSURF.EQ.1 ) WRITE(IFLRO,ERR=900) FREND
      IF( LSURF.EQ.1 ) WRITE(IFLRO,ERR=900) HDEP
      IF( LSURF.EQ.1.AND.IPARNT.GE.0 ) WRITE(IFLRO,ERR=900) HHBCN
      IF( LSURF.EQ.1.AND.IPARNT.GE.0 ) WRITE(IFLRO,ERR=900) UUBCN
      IF( LSURF.EQ.1.AND.IPARNT.GE.0 ) WRITE(IFLRO,ERR=900) VVBCN
C
      RETURN
  900 CONTINUE
      CALL ERRMSG('OUTRST',7180)
      WRITE(LP,*) 'WRITE ERROR: RESTART OUTPUT FILE'
      CALL ABORT1('')
 9510 FORMAT( ' ','>> FILE-RSO : OUT : STEP=',I7,' : TIME= ',1PE12.5)
      END