; IMAGE.ASM
;
; MI01 - TP Assembleur 2 � 5
;
; R�alise le traitement d'une image 32 bits.

.686
.MODEL FLAT, C

.DATA

.CODE

; **********************************************************************
; Sous-programme _process_image_asm
;
; R�alise le traitement d'une image 32 bits.
;
; Entr�es sur la pile : Largeur de l'image (entier 32 bits)
;           Hauteur de l'image (entier 32 bits)
;           Pointeur sur l'image source (d�pl. 32 bits)
;           Pointeur sur l'image tampon 1 (d�pl. 32 bits)
;           Pointeur sur l'image tampon 2 (d�pl. 32 bits)
;           Pointeur sur l'image finale (d�pl. 32 bits)
; **********************************************************************
PUBLIC      process_image_asm
 
process_image_asm   PROC NEAR       ; Point d'entr�e du sous programme
 
    push    ebp
 
    mov     ebp, esp

    push    ebx
 
    push    esi
 
    push    edi
 
        ;r�cup�ration des arguments dans les diff�rents registres
 
        mov     ecx, [ebp + 8]
 
        imul    ecx, [ebp + 12]
 
        mov     esi, [ebp + 16]
 
        mov     edi, [ebp + 20]
 
        xor     edx,edx
 
        ;d�but de la boucle
 
boucle: dec      ecx
 
        ;on r�cup�re le pixel de l'image source � traiter
 
        mov     ebx,[esi+ecx*4]
 
        ;-------------------
 
        ;calcul de B * 0,114
 
        ;-------------------
        mov       eax,ebx
 
        ;on r�cupere la composante bleu dans eax
 
        and      eax,000000FFh
 
        ;on effectue le calcul
 
        imul   eax,1Dh ;B * 0,114
 
        ;on stock la somme (I) dans edx
 
        mov      edx,eax
 
        ;-------------------
 
        ;calcul de V *,0,587
 
        ;-------------------
 
        ;on r�cupere la composante verte dans eax
 
        mov       eax,ebx
 
        and      eax,0000FF00h
 
        shr     eax,8
 
        ;on effectue le calcul
 
        imul   eax,96h ;V *,0,587
 
        add      edx,eax ;I=I+V *,0,587
 
        ;-------------------
 
        ;calcul de R*0,299
 
        ;-------------------
 
        ;on r�cupere la composante rouge dans eax
 
        mov       eax,ebx
 
        and      eax,00FF0000h
 
        shr     eax,16
 
        ;on effectue le calcul
 
        imul   eax,4Ch
 
        add      edx,eax ;I=I+R*0,299
 

 
        ;on divise par 256
 
        shr     edx,8
 
        ;on stock I dans la composante bleu de l'image destination
 
        mov     [edi+ecx*4],edx
 
        cmp    ecx, 0
 
        ja     boucle
 
    ;tp6
 
    mov ecx,[ebp+12];hauteur
 
    sub ecx,2
 
    shl ecx,16
 
    mov     esi,edi;img tmp1
 
    mov     edi, [ebp + 24];img tmp2
 
    mov     ebp, [ebp + 8] ; largeur
 
    mov    eax,ebp  ;eax=largeur
 
    shl    eax,2    ; on multiplie la largeur par 4 ;taille  d'une ligne
 
    add    edi,eax ; on ajoute au premier pixel de l'image tmp2 4*largeur
 
    add    edi, 4
 
  boucle3:	;it�ration sur les lignes
 
    add    ecx,ebp
 
    sub     ecx,2	;on ne prend pas en compte la premi�re et la derni�re colone
 

 
  boucle2: ;it�ration sur les colones
 
  ;--------------
 
 
    ;calcul de Gx avec le masque de convolution Sx (on effectue pas les multiplications par 1 pour �conomiser des instructions). Le r�sultat est stock� dans ebx, on effectue les calculs interm�diaires dans eax.
 
    xor    ebx, ebx
 
    mov    ebx, [esi]
 
    imul  ebx,-1
 
    add    ebx,[esi+8]
 
    mov    eax,[esi+ebp*4]
 
    imul  eax,-2
 
    add    ebx,eax
 
    mov    eax,[esi+ebp*4+8]
 
    imul  eax,2
 
    add    ebx,eax
 
    mov    eax,[esi+ebp*8]
 
    imul  eax,-1
 
    add    ebx,eax
 
    add    ebx,[esi+ebp*8+8]
 
	;calcul de Gy avec le masque de convolution Sy (on effectue pas les multiplications par 1 pour �conomiser des instructions). Le r�sultat est stock� dans edx, les valeurs temporaires sont dans eax.
 
 
    xor    edx, edx
 
    mov    edx, [esi]
 
    mov    eax,[esi+4]
 
    imul  eax,2
 
    add    edx, eax
 
    mov    eax,[esi+8]
 
    add    edx, eax
 
    mov    eax,[esi+ebp*8]
 
    imul  eax,-1
 
    add    edx,eax
 
    mov    eax,[esi+ebp*8+4]
 
    imul  eax,-2
 
    add    edx,eax
 
    mov    eax,[esi+ebp*8+8]
 
    imul  eax,-1
 
    add    edx,eax
 
    cmp  ebx,0	; on v�rifie si le r�sultat de Gx est n�gatif
 
    jg    gx_positif ; si il ne l'est pas on passe � "gx_positif"
 
    neg    ebx	;si le r�sultat est n�gatif on le passe en positif car on souhaite la valeur absolue.
 
 
  
  gx_positif :
 
    cmp  edx, 0	; on fait de meme pour Gy, on v�rifie si il est n�gatif, si il l'est on le passe en positif
 
    jg    gy_positif
 
    neg    edx
 

 
  gy_positif :
 
  add ebx, edx	; on ajoute ensemble la valeur absolue de Gx et Gy
    
 
    xor eax, eax
 
    mov  eax, 255
 
    sub eax, ebx	;pour inverser les couleurs on soustrait � 255 la valeur de chaque pixel
 
    cmp  eax, 0 ;si la valeur obtenue est inf�rieur � 0 on la passe � 0 car on ne peut pas avoir une valeur d'intensit� n�gative.
 
    jg    g_positif
 
    xor eax,eax
 
    g_positif:
 
		mov edx, eax	;on place la valeur obtenue pour qu'elle se trouve dans la composante d'intensit� du pixel
 
		shl edx, 8	

		add eax, edx
 		
 		shl edx, 8
 		
 		add eax, edx
 
    mov  [edi], eax
 
  ;--------------
 
    add esi, 4
 
    add edi, 4
 
    dec ecx
 
    test ecx, 0000ffffh; ;on test si on est arriv� au bout de la ligne
 
    jne     boucle2 ;on revient � l'it�ration sur les colones
 
    add esi, 8
 
    add edi, 8
 
    sub ecx, 00010000h ; on passe � la ligne suivante
 
    jnz    boucle3 ;on revient � l'it�ration sur les lignes
 
fin:
 
    pop     edi
 
    pop     esi
 
    pop     ebx
 
    pop     ebp
 
        ret                         ; Retour a la fonction MainWndProc
 
 
process_image_asm   ENDP
 
END
