#include <kos.h>
#include <kos/fs.h>
#include <dc/pvr.h>
#include <dc/syscalls.h>
#include <dc/sound/sound.h>
#include <dc/sound/sfxmgr.h>
#include <dc/vmu_fb.h>
#include <jpeg/jpeglib.h>
#include <zlib/zlib.h>
int cur = 1;
int top = 29;
char *covers[] = { "/cd/cds/00.crp.gz", "/cd/cds/01.crp.gz", "/cd/cds/02.crp.gz", "/cd/cds/03.crp.gz", "/cd/cds/04.crp.gz", "/cd/cds/05.crp.gz", "/cd/cds/06.crp.gz", "/cd/cds/07.crp.gz", "/cd/cds/08.crp.gz", "/cd/cds/09.crp.gz", "/cd/cds/10.crp.gz", "/cd/cds/11.crp.gz", "/cd/cds/12.crp.gz", "/cd/cds/13.crp.gz", "/cd/cds/14.crp.gz", "/cd/cds/15.crp.gz", "/cd/cds/16.crp.gz", "/cd/cds/17.crp.gz", "/cd/cds/18.crp.gz", "/cd/cds/19.crp.gz", "/cd/cds/20.crp.gz", "/cd/cds/21.crp.gz", "/cd/cds/22.crp.gz", "/cd/cds/23.crp.gz", "/cd/cds/24.crp.gz", "/cd/cds/25.crp.gz", "/cd/cds/26.crp.gz", "/cd/cds/27.crp.gz", "/cd/cds/28.crp.gz", "/cd/cds/29.crp.gz", "/cd/cds/30.crp.gz" };
char *titles[] = { "/cd/cds/00.tex.gz", "/cd/cds/01.tex.gz", "/cd/cds/02.tex.gz", "/cd/cds/03.tex.gz", "/cd/cds/04.tex.gz", "/cd/cds/05.tex.gz", "/cd/cds/06.tex.gz", "/cd/cds/07.tex.gz", "/cd/cds/08.tex.gz", "/cd/cds/09.tex.gz", "/cd/cds/10.tex.gz", "/cd/cds/11.tex.gz", "/cd/cds/12.tex.gz", "/cd/cds/13.tex.gz", "/cd/cds/14.tex.gz", "/cd/cds/15.tex.gz", "/cd/cds/16.tex.gz", "/cd/cds/17.tex.gz", "/cd/cds/18.tex.gz", "/cd/cds/19.tex.gz", "/cd/cds/20.tex.gz", "/cd/cds/21.tex.gz", "/cd/cds/22.tex.gz", "/cd/cds/23.tex.gz", "/cd/cds/24.tex.gz", "/cd/cds/25.tex.gz", "/cd/cds/26.tex.gz", "/cd/cds/27.tex.gz", "/cd/cds/28.tex.gz", "/cd/cds/29.tex.gz", "/cd/cds/30.tex.gz" };
char *videos[] = { "", "/cd/mlf/01.mlf", "/cd/mlf/02.mlf", "/cd/mlf/03.mlf", "/cd/mlf/04.mlf", "/cd/mlf/05.mlf", "/cd/mlf/06.mlf", "/cd/mlf/07.mlf", "/cd/mlf/08.mlf", "/cd/mlf/09.mlf", "/cd/mlf/10.mlf", "/cd/mlf/11.mlf", "/cd/mlf/12.mlf", "/cd/mlf/13.mlf", "/cd/mlf/14.mlf", "/cd/mlf/15.mlf", "/cd/mlf/16.mlf", "/cd/mlf/17.mlf", "/cd/mlf/18.mlf", "/cd/mlf/19.mlf", "/cd/mlf/20.mlf", "/cd/mlf/21.mlf", "/cd/mlf/22.mlf", "/cd/mlf/23.mlf", "/cd/mlf/24.mlf", "/cd/mlf/25.mlf", "/cd/mlf/26.mlf", "/cd/mlf/27.mlf", "/cd/mlf/28.mlf", "/cd/mlf/29.mlf", "" };
int aspects[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 };
int pairs[] = { 0, 1130, 5225, 733, 2057, 275, 4843, 2695, 688, 983, 644, 607, 838, 1096, 1550, 658, 972, 2483, 969, 2923, 1472, 2111, 474, 1147, 2337, 1730, 1396, 1597, 1922, 820, 0 };
struct jpeg_decompress_struct eng;
struct jpeg_error_mgr err;
uint8_t __attribute__ ((aligned(32))) yuv[5120];
unsigned char ** yuv_pl[3];
unsigned char * yuv_pl_y[8];
unsigned char * yuv_pl_u[8];
unsigned char * yuv_pl_v[8];
unsigned char __attribute__ ((aligned(32))) yuv_pl_buf[5120];
int tx_i = 0;
file_t bfh = -1;
uint8_t __attribute__ ((aligned(32))) blk_set[12288];
snd_stream_hnd_t ost_strm;
uint8_t __attribute__ ((aligned(32))) ost_buf[8192];
int ost_i = 0;
int ost_skp = 0;
int ost_lst = 0;
sfxhnd_t drip = 0;
snd_stream_hnd_t mnu_strm;
uint8_t __attribute__ ((aligned(32))) mbf[8192];
uint8_t __attribute__ ((aligned(32))) msr[1874944];
int msr_i = 242652;
uint64 vsync = 0;
pvr_poly_hdr_t hd;
pvr_poly_cxt_t ctx;
pvr_vertex_t tv_v[4];
pvr_vertex_t fs_v[4];
pvr_vertex_t flr_v[4];
pvr_vertex_t cd_v[4];
pvr_vertex_t blr_v[4];
pvr_vertex_t vrt;
pvr_ptr_t tv_tx;
pvr_ptr_t grd_tx;
pvr_ptr_t lgo_tx;
pvr_ptr_t cd_tx[4];
pvr_ptr_t flr_tx[3];
pvr_ptr_t blr_tx;
gzFile gzf = NULL;
uint8_t __attribute__ ((aligned(32))) fs_buf[2097152];
uint8_t *splash;
maple_device_t *pd;
uint32_t btns;
int numb = 0;
void *vmu_imgs;
vmufb_t vmufb;
maple_device_t *vmu;
float polarity = 1;
float offsets[] = { -345, 0, 345 };
float deltas[] = { -2.55555570e+0, 0, 2.55555570e+0 };
int textures[] = { 0, 1, 2 };
int para_offsets[] = { 29, 149, 269 };
float offset;
float delta;
int texture;
int para_offset = 0;
float anim_offsets[] = { 0.00000000e+0, 2.44484990e-1, 9.77246940e-1, 2.19620870e+0, 3.89791550e+0, 6.07754300e+0, 8.72891250e+0, 1.18445090e+1, 1.54155020e+1, 1.94317670e+1, 2.38819210e+1, 2.87533500e+1, 3.40322400e+1, 3.97036400e+1, 4.57514580e+1, 5.21585640e+1, 5.89067900e+1, 6.59770100e+1, 7.33491660e+1, 8.10024000e+1, 8.89149800e+1, 9.70644900e+1, 1.05427824e+2, 1.13981290e+2, 1.22700630e+2, 1.31561150e+2, 1.40537710e+2, 1.49604840e+2, 1.58736900e+2, 1.67907950e+2, 1.77092050e+2, 1.86263100e+2, 1.95395160e+2, 2.04462300e+2, 2.13438850e+2, 2.22299370e+2, 2.31018690e+2, 2.39572170e+2, 2.47935530e+2, 2.56085000e+2, 2.63997600e+2, 2.71650820e+2, 2.79023020e+2, 2.86093240e+2, 2.92841430e+2, 2.99248550e+2, 3.05296360e+2, 3.10967770e+2, 3.16246630e+2, 3.21118100e+2, 3.25568230e+2, 3.29584500e+2, 3.33155480e+2, 3.36271080e+2, 3.38922440e+2, 3.41102100e+2, 3.42803800e+2, 3.44022780e+2, 3.44755530e+2, 3.45000000e+2 };
float anim_deltas[] = { 0.00000000e+0, 1.81100000e-3, 7.23886600e-3, 1.62682120e-2, 2.88734470e-2, 4.50188370e-2, 6.46586060e-2, 8.77371100e-2, 1.14188900e-1, 1.43939000e-1, 1.76903130e-1, 2.12987770e-1, 2.52090660e-1, 2.94101030e-1, 3.38899700e-1, 3.86359750e-1, 4.36346560e-1, 4.88718540e-1, 5.43327150e-1, 6.00017800e-1, 6.58629500e-1, 7.18996200e-1, 7.80946850e-1, 8.44305900e-1, 9.08893600e-1, 9.74527060e-1, 1.04102000e+0, 1.10818410e+0, 1.17582880e+0, 1.24376260e+0, 1.31179300e+0, 1.37972670e+0, 1.44737150e+0, 1.51453570e+0, 1.58102860e+0, 1.64666200e+0, 1.71124960e+0, 1.77460880e+0, 1.83655950e+0, 1.89692600e+0, 1.95553800e+0, 2.01222820e+0, 2.06683710e+0, 2.11920900e+0, 2.16919590e+0, 2.21665590e+0, 2.26145460e+0, 2.30346490e+0, 2.34256770e+0, 2.37865240e+0, 2.41161660e+0, 2.44136660e+0, 2.46781860e+0, 2.49089690e+0, 2.51053660e+0, 2.52668200e+0, 2.53928720e+0, 2.54831670e+0, 2.55374460e+0, 2.55555570e+0 };
float anim_para_offsets[] = { 0.00000000e+0, 5.33333360e+0, 1.06666670e+1, 1.60000000e+1, 2.13333340e+1, 2.66666650e+1, 3.20000000e+1, 3.73333330e+1, 4.26666680e+1, 4.80000000e+1, 5.33333300e+1, 5.86666700e+1, 6.40000000e+1, 6.93333400e+1, 7.46666670e+1, 8.00000000e+1, 8.53333350e+1, 9.06666640e+1, 9.60000000e+1, 1.01333335e+2, 1.06666660e+2, 1.12000000e+2, 1.17333340e+2, 1.22666664e+2, 1.28000000e+2, 1.33333330e+2, 1.38666670e+2, 1.44000000e+2, 1.49333330e+2, 1.54666680e+2, 1.60000000e+2, 1.65333330e+2, 1.70666660e+2, 1.76000000e+2, 1.81333330e+2, 1.86666670e+2, 1.92000000e+2, 1.97333320e+2, 2.02666670e+2, 2.08000000e+2, 2.13333320e+2, 2.18666670e+2, 2.24000000e+2, 2.29333330e+2, 2.34666680e+2, 2.40000000e+2, 2.45333330e+2, 2.50666680e+2, 2.56000000e+2, 2.61333350e+2, 2.66666650e+2, 2.72000000e+2, 2.77333350e+2, 2.82666650e+2, 2.88000000e+2, 2.93333350e+2, 2.98666660e+2, 3.04000000e+2, 3.09333350e+2, 3.14666660e+2, 3.20000000e+2, 3.25333360e+2, 3.30666660e+2, 3.36000000e+2, 3.41333330e+2, 3.46666660e+2, 3.52000000e+2, 3.57333330e+2, 3.62666670e+2, 3.68000000e+2, 3.73333330e+2, 3.78666670e+2, 3.84000000e+2, 3.89333340e+2, 3.94666640e+2, 4.00000000e+2, 4.05333340e+2, 4.10666640e+2, 4.16000000e+2, 4.21333340e+2, 4.26666650e+2, 4.32000000e+2, 4.37333350e+2, 4.42666650e+2, 4.48000000e+2, 4.53333350e+2, 4.58666650e+2, 4.64000000e+2, 4.69333350e+2, 4.74666660e+2, 4.80000000e+2, 4.85333350e+2, 4.90666660e+2, 4.96000000e+2, 5.01333360e+2, 5.06666660e+2, 5.12000000e+2, 5.17333300e+2, 5.22666700e+2, 5.28000000e+2, 5.33333300e+2, 5.38666670e+2, 5.44000000e+2, 5.49333330e+2, 5.54666700e+2, 5.60000000e+2, 5.65333300e+2, 5.70666700e+2, 5.76000000e+2, 5.81333340e+2, 5.86666700e+2, 5.92000000e+2, 5.97333300e+2, 6.02666700e+2, 6.08000000e+2, 6.13333300e+2, 6.18666700e+2, 6.24000000e+2, 6.29333300e+2, 6.34666700e+2, 6.40000000e+2, 6.45333300e+2, 6.50666700e+2, 6.56000000e+2, 6.61333300e+2, 6.66666700e+2, 6.72000000e+2, 6.77333300e+2, 6.82666660e+2, 6.88000000e+2, 6.93333300e+2, 6.98666700e+2, 7.04000000e+2, 7.09333300e+2, 7.14666660e+2, 7.20000000e+2, 7.25333330e+2, 7.30666700e+2, 7.36000000e+2, 7.41333300e+2, 7.46666670e+2, 7.52000000e+2, 7.57333340e+2, 7.62666700e+2, 7.68000000e+2, 7.73333300e+2, 7.78666700e+2, 7.84000000e+2, 7.89333300e+2, 7.94666700e+2, 8.00000000e+2, 8.05333300e+2, 8.10666700e+2, 8.16000000e+2, 8.21333300e+2, 8.26666700e+2, 8.32000000e+2, 8.37333300e+2, 8.42666700e+2, 8.48000000e+2, 8.53333300e+2, 8.58666660e+2, 8.64000000e+2, 8.69333300e+2, 8.74666700e+2, 8.80000000e+2, 8.85333300e+2, 8.90666660e+2, 8.96000000e+2, 9.01333330e+2, 9.06666700e+2, 9.12000000e+2, 9.17333300e+2, 9.22666670e+2, 9.28000000e+2, 9.33333340e+2, 9.38666700e+2, 9.44000000e+2, 9.49333300e+2, 9.54666700e+2, 9.60000000e+2, -9.54666700e+2, -9.49333300e+2, -9.44000000e+2, -9.38666700e+2, -9.33333340e+2, -9.28000000e+2, -9.22666670e+2, -9.17333300e+2, -9.12000000e+2, -9.06666700e+2, -9.01333330e+2, -8.96000000e+2, -8.90666600e+2, -8.85333360e+2, -8.80000000e+2, -8.74666630e+2, -8.69333400e+2, -8.64000000e+2, -8.58666600e+2, -8.53333350e+2, -8.48000000e+2, -8.42666600e+2, -8.37333400e+2, -8.32000000e+2, -8.26666650e+2, -8.21333350e+2, -8.16000000e+2, -8.10666600e+2, -8.05333400e+2, -8.00000000e+2, -7.94666650e+2, -7.89333400e+2, -7.84000000e+2, -7.78666600e+2, -7.73333400e+2, -7.68000000e+2, -7.62666640e+2, -7.57333400e+2, -7.52000000e+2, -7.46666600e+2, -7.41333370e+2, -7.36000000e+2, -7.30666640e+2, -7.25333400e+2, -7.20000000e+2, -7.14666600e+2, -7.09333360e+2, -7.04000000e+2, -6.98666630e+2, -6.93333400e+2, -6.88000000e+2, -6.82666600e+2, -6.77333350e+2, -6.72000000e+2, -6.66666600e+2, -6.61333400e+2, -6.56000000e+2, -6.50666650e+2, -6.45333350e+2, -6.40000000e+2, -6.34666600e+2, -6.29333400e+2, -6.24000000e+2, -6.18666650e+2, -6.13333340e+2, -6.08000000e+2, -6.02666600e+2, -5.97333400e+2, -5.92000000e+2, -5.86666640e+2, -5.81333400e+2, -5.76000000e+2, -5.70666600e+2, -5.65333370e+2, -5.60000000e+2, -5.54666640e+2, -5.49333400e+2, -5.44000000e+2, -5.38666600e+2, -5.33333360e+2, -5.28000000e+2, -5.22666630e+2, -5.17333400e+2, -5.12000000e+2, -5.06666600e+2, -5.01333360e+2, -4.96000000e+2, -4.90666630e+2, -4.85333380e+2, -4.80000000e+2, -4.74666630e+2, -4.69333380e+2, -4.64000000e+2, -4.58666620e+2, -4.53333380e+2, -4.48000000e+2, -4.42666620e+2, -4.37333380e+2, -4.32000000e+2, -4.26666620e+2, -4.21333370e+2, -4.16000000e+2, -4.10666600e+2, -4.05333370e+2, -4.00000000e+2, -3.94666600e+2, -3.89333370e+2, -3.84000000e+2, -3.78666640e+2, -3.73333360e+2, -3.68000000e+2, -3.62666640e+2, -3.57333360e+2, -3.52000000e+2, -3.46666630e+2, -3.41333360e+2, -3.36000000e+2, -3.30666630e+2, -3.25333400e+2, -3.20000000e+2, -3.14666630e+2, -3.09333380e+2, -3.04000000e+2, -2.98666630e+2, -2.93333380e+2, -2.88000000e+2, -2.82666620e+2, -2.77333380e+2, -2.72000000e+2, -2.66666620e+2, -2.61333380e+2, -2.56000000e+2, -2.50666620e+2, -2.45333370e+2, -2.40000000e+2, -2.34666630e+2, -2.29333370e+2, -2.24000000e+2, -2.18666630e+2, -2.13333370e+2, -2.08000000e+2, -2.02666630e+2, -1.97333380e+2, -1.92000000e+2, -1.86666620e+2, -1.81333380e+2, -1.76000000e+2, -1.70666620e+2, -1.65333380e+2, -1.60000000e+2, -1.54666630e+2, -1.49333370e+2, -1.44000000e+2, -1.38666630e+2, -1.33333370e+2, -1.28000000e+2, -1.22666630e+2, -1.17333375e+2, -1.12000000e+2, -1.06666625e+2, -1.01333370e+2, -9.60000000e+1, -9.06666300e+1, -8.53333700e+1, -8.00000000e+1, -7.46666250e+1, -6.93333750e+1, -6.40000000e+1, -5.86666300e+1, -5.33333700e+1, -4.80000000e+1, -4.26666260e+1, -3.73333750e+1, -3.20000000e+1, -2.66666260e+1, -2.13333740e+1, -1.60000000e+1, -1.06666260e+1, -5.33337400e+0 };
uint64_t mark;

void * ost_poll(snd_stream_hnd_t __attribute__ ((unused())) ign, int req, int *n)
{
	memmove(ost_buf, ost_buf + ost_lst, 8192 - ost_lst);
	ost_i -= ost_lst;
	if (req > ost_i)
		ost_skp = 1;
	else
		ost_skp = 0;
	ost_lst = 0;
	while ((req >= 2048) && ((ost_lst + 2048) <= ost_i))  {
		req -= 2048;
		ost_lst += 2048;
	}
	*n = ost_lst;
	if (0 == ost_lst)
		return ((void *)NULL);
	else
		return ((void *)ost_buf);
}

void * mnu_poll(snd_stream_hnd_t __attribute__ ((unused())) ign, int req, int *n)
{
	for(int i = 0; i < req; i++) {
		*(mbf + i) = *(msr + msr_i++);
		if (msr_i > 1874943)
			msr_i = 0;
	}
	*n = req;
	return ((void *)mbf);
}

void * fetch(void __attribute__ ((unused())) *ign)
{
	gzread(gzf, fs_buf, 394240);
	gzclose(gzf);
	gzf = gzopen(titles[cur], "r");
	if (NULL == gzf)
		return NULL;
	gzread(gzf, fs_buf + 394240, 125440);
	gzclose(gzf);
	return NULL;
}

void buttons(void)
{
	if (numb-- > 0) {
		btns = 0;
		return;
	}
	pd = maple_enum_type(0, MAPLE_FUNC_CONTROLLER);
	if (pd)
		btns = ((cont_state_t *)maple_dev_status(pd))->buttons;
}

void vmu_img(int qid)
{
	vmufb_clear(&vmufb);
	vmufb_paint_area(&vmufb, 0, 0, 48, 32, vmu_imgs + (192 * qid));
	vmu = maple_enum_type(0, MAPLE_FUNC_LCD);
	if (NULL != vmu)
		vmufb_present(&vmufb, vmu);
}

void show_blank(void)
{
	pvr_wait_ready();
	pvr_scene_begin();
	pvr_scene_finish();
}

void draw_dynamic(pvr_list_t typ, int twd, pvr_ptr_t tx, int span, pvr_vertex_t lst[])
{
	pvr_poly_cxt_txr(&ctx, typ, PVR_TXRFMT_ARGB1555 | PVR_TXRFMT_NOSTRIDE | twd | PVR_TXRFMT_VQ_DISABLE, span, span, tx, PVR_FILTER_NONE);
	pvr_poly_compile(&hd, &ctx);
	pvr_prim(&hd, sizeof(hd));
	for(int i = 0; i < 4; i++) {
		vrt = lst[i];
		mat_trans_single3_nodiv(vrt.x, vrt.y, vrt.z);
		pvr_prim(&vrt, sizeof(pvr_vertex_t));
	}
}

void draw_static(pvr_list_t typ, int twd, pvr_ptr_t tx, int span, pvr_vertex_t lst[])
{
	pvr_poly_cxt_txr(&ctx, typ, PVR_TXRFMT_ARGB1555 | PVR_TXRFMT_NOSTRIDE | twd | PVR_TXRFMT_VQ_DISABLE, span, span, tx, PVR_FILTER_NONE);
	pvr_poly_compile(&hd, &ctx);
	pvr_prim(&hd, sizeof(hd));
	for(int i = 0; i < 4; i++) {
		pvr_prim(lst + i, sizeof(pvr_vertex_t));
	}
}

void show_logo(void)
{
	pvr_wait_ready();
	pvr_scene_begin();
	pvr_list_begin(PVR_LIST_OP_POLY);
	draw_static(PVR_LIST_OP_POLY, PVR_TXRFMT_TWIDDLED, lgo_tx, 1024, fs_v);
	pvr_list_finish();
	pvr_scene_finish();
}

void a43(void)
{
	tv_v[0].x = 0;
	tv_v[0].y = 0;
	tv_v[1].x = 640;
	tv_v[1].y = 0;
	tv_v[2].x = 0;
	tv_v[2].y = 480;
	tv_v[3].x = 640;
	tv_v[3].y = 480;
}

void a169(void)
{
	tv_v[0].x = 0;
	tv_v[0].y = 60;
	tv_v[1].x = 640;
	tv_v[1].y = 60;
	tv_v[2].x = 0;
	tv_v[2].y = 420;
	tv_v[3].x = 640;
	tv_v[3].y = 420;
}

void frame_x(int adj)
{
	pvr_wait_ready();
	pvr_scene_begin();
	pvr_list_begin(PVR_LIST_OP_POLY);
	pvr_poly_cxt_txr(&ctx, PVR_LIST_OP_POLY, PVR_TXRFMT_YUV422 | PVR_TXRFMT_VQ_DISABLE | PVR_TXRFMT_NONTWIDDLED | 33554432, 512, 512, tv_tx + (adj * 102400), PVR_FILTER_NONE);
	pvr_poly_compile(&hd, &ctx);
	pvr_prim(&hd, sizeof(hd));
	for(int i = 0; i < 4; i++) {
		pvr_prim(tv_v + i, sizeof(pvr_vertex_t));
	}
	pvr_list_finish();
	pvr_scene_finish();
}

int main(int argc __attribute__ ((unused)), char *argv[] __attribute__ ((unused)))
{
	int state = 0;
	int sub_timer = 0;
	int pairs_togo = 947;
	int next = 1;
	while (1)  {
		switch (state)
		{
			case 0:
				if (vid_check_cable() == CT_VGA)
					vid_set_mode(DM_640x480_VGA, PM_RGB565);
				else
					vid_set_mode(DM_640x480_NTSC_IL, PM_RGB565);
				static pvr_init_params_t cfg = { { PVR_BINSIZE_8, PVR_BINSIZE_0, PVR_BINSIZE_0, PVR_BINSIZE_0, PVR_BINSIZE_8 }, 524288, 0, 0, 1, 0 };
				pvr_init(&cfg);
				PVR_SET(PVR_TEXTURE_MODULO, 10);
				tv_tx = pvr_mem_malloc(4369408);
				grd_tx = tv_tx + 204800;
				lgo_tx = grd_tx + 1243136;
				cd_tx[0] = lgo_tx + 1243136;
				cd_tx[1] = cd_tx[0] + 394240;
				cd_tx[2] = cd_tx[1] + 394240;
				flr_tx[0] = cd_tx[2] + 394240;
				flr_tx[1] = flr_tx[0] + 123392;
				flr_tx[2] = flr_tx[1] + 123392;
				blr_tx = flr_tx[2] + 123392;
				tv_v[0].flags = PVR_CMD_VERTEX;
				tv_v[0].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				tv_v[0].x = 0;
				tv_v[0].y = 0;
				tv_v[0].z = 1;
				tv_v[0].u = 0;
				tv_v[0].v = 0;
				tv_v[1].flags = PVR_CMD_VERTEX;
				tv_v[1].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				tv_v[1].x = 640;
				tv_v[1].y = 0;
				tv_v[1].z = 1;
				tv_v[1].u = 6.25000000e-1;
				tv_v[1].v = 0;
				tv_v[2].flags = PVR_CMD_VERTEX;
				tv_v[2].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				tv_v[2].x = 0;
				tv_v[2].y = 480;
				tv_v[2].z = 1;
				tv_v[2].u = 0;
				tv_v[2].v = 3.12500000e-1;
				tv_v[3].flags = PVR_CMD_VERTEX_EOL;
				tv_v[3].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				tv_v[3].x = 640;
				tv_v[3].y = 480;
				tv_v[3].z = 1;
				tv_v[3].u = 6.25000000e-1;
				tv_v[3].v = 3.12500000e-1;
				fs_v[0].flags = PVR_CMD_VERTEX;
				fs_v[0].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				fs_v[0].x = 0;
				fs_v[0].y = 0;
				fs_v[0].z = 1;
				fs_v[0].u = 0;
				fs_v[0].v = 0;
				fs_v[1].flags = PVR_CMD_VERTEX;
				fs_v[1].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				fs_v[1].x = 640;
				fs_v[1].y = 0;
				fs_v[1].z = 1;
				fs_v[1].u = 6.25000000e-1;
				fs_v[1].v = 0;
				fs_v[2].flags = PVR_CMD_VERTEX;
				fs_v[2].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				fs_v[2].x = 0;
				fs_v[2].y = 480;
				fs_v[2].z = 1;
				fs_v[2].u = 0;
				fs_v[2].v = 4.68750000e-1;
				fs_v[3].flags = PVR_CMD_VERTEX_EOL;
				fs_v[3].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				fs_v[3].x = 640;
				fs_v[3].y = 480;
				fs_v[3].z = 1;
				fs_v[3].u = 6.25000000e-1;
				fs_v[3].v = 4.68750000e-1;
				flr_v[0].flags = PVR_CMD_VERTEX;
				flr_v[0].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				flr_v[0].x = 220;
				flr_v[0].y = 132;
				flr_v[0].z = 3;
				flr_v[0].u = 0;
				flr_v[0].v = 0;
				flr_v[1].flags = PVR_CMD_VERTEX;
				flr_v[1].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				flr_v[1].x = 420;
				flr_v[1].y = 132;
				flr_v[1].z = 3;
				flr_v[1].u = 7.81250000e-1;
				flr_v[1].v = 0;
				flr_v[2].flags = PVR_CMD_VERTEX;
				flr_v[2].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				flr_v[2].x = 220;
				flr_v[2].y = 332;
				flr_v[2].z = 3;
				flr_v[2].u = 0;
				flr_v[2].v = 7.81250000e-1;
				flr_v[3].flags = PVR_CMD_VERTEX_EOL;
				flr_v[3].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				flr_v[3].x = 420;
				flr_v[3].y = 332;
				flr_v[3].z = 3;
				flr_v[3].u = 7.81250000e-1;
				flr_v[3].v = 7.81250000e-1;
				cd_v[0].flags = PVR_CMD_VERTEX;
				cd_v[0].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				cd_v[0].x = 185;
				cd_v[0].y = 113;
				cd_v[0].z = 4;
				cd_v[0].u = 0;
				cd_v[0].v = 0;
				cd_v[1].flags = PVR_CMD_VERTEX;
				cd_v[1].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				cd_v[1].x = 455;
				cd_v[1].y = 113;
				cd_v[1].z = 4;
				cd_v[1].u = 5.27343750e-1;
				cd_v[1].v = 0;
				cd_v[2].flags = PVR_CMD_VERTEX;
				cd_v[2].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				cd_v[2].x = 185;
				cd_v[2].y = 383;
				cd_v[2].z = 4;
				cd_v[2].u = 0;
				cd_v[2].v = 5.27343750e-1;
				cd_v[3].flags = PVR_CMD_VERTEX_EOL;
				cd_v[3].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				cd_v[3].x = 455;
				cd_v[3].y = 383;
				cd_v[3].z = 4;
				cd_v[3].u = 5.27343750e-1;
				cd_v[3].v = 5.27343750e-1;
				blr_v[0].flags = PVR_CMD_VERTEX;
				blr_v[0].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				blr_v[0].x = 0;
				blr_v[0].y = 382;
				blr_v[0].z = 2;
				blr_v[0].u = 0;
				blr_v[0].v = 0;
				blr_v[1].flags = PVR_CMD_VERTEX;
				blr_v[1].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				blr_v[1].x = 640;
				blr_v[1].y = 382;
				blr_v[1].z = 2;
				blr_v[1].u = 6.25000000e-1;
				blr_v[1].v = 0;
				blr_v[2].flags = PVR_CMD_VERTEX;
				blr_v[2].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				blr_v[2].x = 0;
				blr_v[2].y = 480;
				blr_v[2].z = 2;
				blr_v[2].u = 0;
				blr_v[2].v = 9.57031250e-2;
				blr_v[3].flags = PVR_CMD_VERTEX_EOL;
				blr_v[3].argb = PVR_PACK_COLOR(1.00000000e+0, 1.00000000e+0, 1.00000000e+0, 1.00000000e+0);
				blr_v[3].x = 640;
				blr_v[3].y = 480;
				blr_v[3].z = 2;
				blr_v[3].u = 6.25000000e-1;
				blr_v[3].v = 9.57031250e-2;
				for(int i = 0; i < 8; i++) {
					yuv_pl_y[i] = yuv_pl_buf + (i * 320);
					yuv_pl_u[i] = yuv_pl_buf + (i * 160) + 2560;
					yuv_pl_v[i] = yuv_pl_buf + (i * 160) + 2560 + 1280;
				}
				yuv_pl[0] = yuv_pl_y;
				yuv_pl[1] = yuv_pl_u;
				yuv_pl[2] = yuv_pl_v;
				eng.err = jpeg_std_error(&err);
				jpeg_create_decompress(&eng);
				vmu_imgs = fs_mmap(fs_open("/rd/vmu.bin", O_RDONLY));
				snd_stream_init();
				ost_strm = snd_stream_alloc(ost_poll, 4096);
				mnu_strm = snd_stream_alloc(mnu_poll, 4096);
				drip = snd_sfx_load("/rd/drip.wav");
				vmu_img(0);
				pvr_set_bg_color(0.00000000e+0, 0.00000000e+0, 0.00000000e+0);
				splash = fs_mmap(fs_open("/rd/splash.tex", O_RDONLY));
				for(int i = 0; i < 480; i++) {
					pvr_txr_load(splash + (i * 1280), lgo_tx + (i * 2048), 1280);
				}
				state = 2;
				break;
			case 2:
				pvr_wait_ready();
				pvr_scene_begin();
				pvr_list_begin(PVR_LIST_OP_POLY);
				draw_static(PVR_LIST_OP_POLY, PVR_TXRFMT_NONTWIDDLED, lgo_tx, 1024, fs_v);
				pvr_list_finish();
				pvr_scene_finish();
				buttons();
				if (btns & CONT_A) {
					snd_sfx_play(drip, 255, 128);
					vmu_img(1);
					state = 1;
				}
				break;
			case 1:
				show_blank();
				mark = timer_ms_gettime64();
				gzf = gzopen("/cd/cds/000.bin.gz", "r");
				gzread(gzf, fs_buf, 1243136);
				pvr_txr_load(fs_buf, lgo_tx, 1243136);
				gzread(gzf, fs_buf, 370176);
				pvr_txr_load(fs_buf, flr_tx[0], 370176);
				while ((timer_ms_gettime64() - mark) < 1250)  {
					thd_pass();
				}
				show_logo();
				mark = timer_ms_gettime64();
				gzread(gzf, fs_buf, 1243136);
				pvr_txr_load(fs_buf, grd_tx, 1243136);
				gzread(gzf, msr, 1874944);
				while ((timer_ms_gettime64() - mark) < 4000)  {
					thd_pass();
				}
				show_blank();
				mark = timer_ms_gettime64();
				gzread(gzf, fs_buf, 1243136);
				pvr_txr_load(fs_buf, lgo_tx, 1243136);
				while ((timer_ms_gettime64() - mark) < 1250)  {
					thd_pass();
				}
				show_logo();
				mark = timer_ms_gettime64();
				gzread(gzf, fs_buf, 1243136);
				pvr_txr_load(fs_buf, lgo_tx, 1243136);
				gzread(gzf, fs_buf, 788480);
				pvr_txr_load(fs_buf, cd_tx[0], 788480);
				gzread(gzf, fs_buf, 394240);
				pvr_txr_load(fs_buf, cd_tx[2], 394240);
				while ((timer_ms_gettime64() - mark) < 4000)  {
					thd_pass();
				}
				show_blank();
				mark = timer_ms_gettime64();
				gzread(gzf, fs_buf, 125440);
				for(int i = 0; i < 98; i++) {
					pvr_txr_load(fs_buf + (i * 1280), blr_tx + (i * 2048), 1280);
				}
				gzclose(gzf);
				while ((timer_ms_gettime64() - mark) < 1250)  {
					thd_pass();
				}
				state = 3;
				break;
			case 3:
				sub_timer = 0;
				polarity = -1;
				offsets[0] = -345;
				offsets[1] = 0;
				offsets[2] = 345;
				deltas[0] = 2.55555570e+0;
				deltas[1] = 0;
				deltas[2] = -2.55555570e+0;
				snd_stream_start_adpcm(mnu_strm, 22050, 1);
				snd_stream_volume(mnu_strm, 192);
				state = 4;
				break;
			case 4:
				for(int f = 0; f < 2; f++) {
					pvr_wait_ready();
					pvr_scene_begin();
					pvr_list_begin(PVR_LIST_OP_POLY);
					draw_static(PVR_LIST_OP_POLY, PVR_TXRFMT_TWIDDLED, grd_tx, 1024, fs_v);
					draw_static(PVR_LIST_OP_POLY, PVR_TXRFMT_NONTWIDDLED, blr_tx, 1024, blr_v);
					pvr_list_finish();
					pvr_list_begin(PVR_LIST_PT_POLY);
					for(int i = 0; i < 3; i++) {
						mat_identity();
						mat_translate(anim_para_offsets[(para_offset + para_offsets[i]) % 360], 0, 0);
						draw_dynamic(PVR_LIST_PT_POLY, PVR_TXRFMT_TWIDDLED, flr_tx[i], 256, flr_v);
					}
					for(int i = 0; i < 3; i++) {
						mat_identity();
						mat_translate(320, 248, 0);
						mat_translate(offsets[i], 0, 0);
						mat_rotate_z(deltas[i]);
						mat_translate(-320, -248, 0);
						draw_dynamic(PVR_LIST_PT_POLY, PVR_TXRFMT_TWIDDLED, cd_tx[textures[i]], 512, cd_v);
					}
					pvr_list_finish();
					snd_stream_poll(mnu_strm);
					if (1 == f) {
						buttons();
						if ((top != cur) && (btns & CONT_DPAD_RIGHT)) {
							polarity = -1;
							state = 6;
						}
						if ((1 != cur) && (btns & CONT_DPAD_LEFT)) {
							polarity = 1;
							state = 6;
						}
						if ((btns & CONT_A) || (btns & CONT_START))
							state = 7;
					}
					pvr_scene_finish();
				}
				break;
			case 6:
				cur = cur - polarity;
				next = cur - polarity;
				gzf = gzopen(covers[next], "r");
				if (NULL == gzf) {
					numb = 15;
					cur = cur + polarity;
					next = cur + polarity;
					state = 3;
					break;
				}
				thd_create(1, fetch, NULL);
				snd_sfx_play(drip, 255, 128);
				sub_timer = 0;
				state = 5;
				break;
			case 5:
				for(int f = 0; f < 2; f++) {
					pvr_wait_ready();
					pvr_scene_begin();
					pvr_list_begin(PVR_LIST_OP_POLY);
					draw_static(PVR_LIST_OP_POLY, PVR_TXRFMT_TWIDDLED, grd_tx, 1024, fs_v);
					pvr_list_finish();
					pvr_list_begin(PVR_LIST_PT_POLY);
					for(int i = 0; i < 3; i++) {
						mat_identity();
						mat_translate(anim_para_offsets[(para_offset + para_offsets[i]) % 360], 0, 0);
						draw_dynamic(PVR_LIST_PT_POLY, PVR_TXRFMT_TWIDDLED, flr_tx[i], 256, flr_v);
					}
					for(int i = 0; i < 3; i++) {
						offset = offsets[i] + (polarity * anim_offsets[sub_timer]);
						if (((polarity * offset) - 455) > 0) {
							pvr_txr_load(fs_buf, cd_tx[textures[i]], 394240);
							offsets[i] = -2 * offsets[i];
							deltas[i] = -2 * deltas[i];
							offset = offsets[i] + (polarity * anim_offsets[sub_timer]);
						}
						mat_identity();
						mat_translate(320, 248, 0);
						mat_translate(offset, 0, 0);
						mat_rotate_z(deltas[i] + (-1 * polarity * anim_deltas[sub_timer]));
						mat_translate(-320, -248, 0);
						draw_dynamic(PVR_LIST_PT_POLY, PVR_TXRFMT_TWIDDLED, cd_tx[textures[i]], 512, cd_v);
					}
					pvr_list_finish();
					snd_stream_poll(mnu_strm);
					pvr_scene_finish();
				}
				para_offset = para_offset + polarity;
				if (para_offset < 0)
					para_offset = 359;
				if (para_offset > 359)
					para_offset = 0;
				if (sub_timer++ > 58) {
					if (polarity > 0) {
						texture = textures[2];
						textures[2] = textures[1];
						textures[1] = textures[0];
						textures[0] = texture;
					}
					else {
						texture = textures[0];
						textures[0] = textures[1];
						textures[1] = textures[2];
						textures[2] = texture;
					}
					for(int i = 0; i < 98; i++) {
						pvr_txr_load(fs_buf + 394240 + (i * 1280), blr_tx + (i * 2048), 1280);
					}
					offsets[0] = -345;
					offsets[1] = 0;
					offsets[2] = 345;
					deltas[0] = 2.55555570e+0;
					deltas[1] = 0;
					deltas[2] = -2.55555570e+0;
					state = 4;
				}
				break;
			case 7:
				numb = 7;
				snd_stream_stop(mnu_strm);
				snd_sfx_play(drip, 255, 128);
				show_logo();
				bfh = fs_open(videos[cur], O_RDONLY);
				if (-1 == bfh) {
					state = 3;
					break;
				}
				snd_stream_start_adpcm(ost_strm, 22050, 1);
				snd_stream_volume(ost_strm, 255);
				pairs_togo = pairs[cur];
				if (aspects[cur])
					a43();
				else
					a169();
				state = 9;
				break;
			case 9:
				if (pairs_togo-- < 1) {
					state = 8;
					break;
				}
				if ((ost_i + 1470) <= 8192) {
					memcpy(ost_buf + ost_i, blk_set, 1470);
					ost_i += 1470;
				}
				ost_skp = 0;
				snd_stream_poll(ost_strm);
				if (ost_skp == 1) {
					fs_read(bfh, blk_set, 12288);
					break;
				}
				frame_x(1);
				vsync = timer_ms_gettime64();
				fs_read(bfh, blk_set, 12288);
				jpeg_mem_src(&eng, blk_set + 1470, 10818);
				jpeg_read_header(&eng, false);
				eng.out_color_space = JCS_YCbCr;
				eng.raw_data_out = true;
				jpeg_start_decompress(&eng);
				tx_i = 0;
				for(int i = 0; i < 10; i++) {
					jpeg_read_raw_data(&eng, yuv_pl, 8);
					for(int i = 0; i < 1280; i++) {
						*(yuv + (i * 4) + 0) = *(yuv_pl_buf + 2560 + i);
						*(yuv + (i * 4) + 1) = *(yuv_pl_buf + (i * 2) + 0);
						*(yuv + (i * 4) + 2) = *(yuv_pl_buf + 3840 + i);
						*(yuv + (i * 4) + 3) = *(yuv_pl_buf + (i * 2) + 1);
					}
					pvr_txr_load(yuv, tv_tx + (tx_i++ * 5120), 5120);
				}
				frame_x(1);
				vsync = timer_ms_gettime64();
				for(int i = 0; i < 10; i++) {
					jpeg_read_raw_data(&eng, yuv_pl, 8);
					for(int i = 0; i < 1280; i++) {
						*(yuv + (i * 4) + 0) = *(yuv_pl_buf + 2560 + i);
						*(yuv + (i * 4) + 1) = *(yuv_pl_buf + (i * 2) + 0);
						*(yuv + (i * 4) + 2) = *(yuv_pl_buf + 3840 + i);
						*(yuv + (i * 4) + 3) = *(yuv_pl_buf + (i * 2) + 1);
					}
					pvr_txr_load(yuv, tv_tx + (tx_i++ * 5120), 5120);
				}
				frame_x(0);
				vsync = timer_ms_gettime64();
				for(int i = 0; i < 10; i++) {
					jpeg_read_raw_data(&eng, yuv_pl, 8);
					for(int i = 0; i < 1280; i++) {
						*(yuv + (i * 4) + 0) = *(yuv_pl_buf + 2560 + i);
						*(yuv + (i * 4) + 1) = *(yuv_pl_buf + (i * 2) + 0);
						*(yuv + (i * 4) + 2) = *(yuv_pl_buf + 3840 + i);
						*(yuv + (i * 4) + 3) = *(yuv_pl_buf + (i * 2) + 1);
					}
					pvr_txr_load(yuv, tv_tx + (tx_i++ * 5120), 5120);
				}
				frame_x(0);
				vsync = timer_ms_gettime64();
				for(int i = 0; i < 10; i++) {
					jpeg_read_raw_data(&eng, yuv_pl, 8);
					for(int i = 0; i < 1280; i++) {
						*(yuv + (i * 4) + 0) = *(yuv_pl_buf + 2560 + i);
						*(yuv + (i * 4) + 1) = *(yuv_pl_buf + (i * 2) + 0);
						*(yuv + (i * 4) + 2) = *(yuv_pl_buf + 3840 + i);
						*(yuv + (i * 4) + 3) = *(yuv_pl_buf + (i * 2) + 1);
					}
					pvr_txr_load(yuv, tv_tx + (tx_i++ * 5120), 5120);
				}
				jpeg_finish_decompress(&eng);
				buttons();
				if (btns)
					state = 8;
				break;
			case 8:
				numb = 15;
				if (-1 != bfh)
					fs_close(bfh);
				snd_stream_stop(ost_strm);
				show_logo();
				state = 3;
				break;
		}
	}
	return 0;
}
