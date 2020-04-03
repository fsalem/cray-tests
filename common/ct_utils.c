/*
 * Copyright (c) 2015-2016 Cray Inc.  All rights reserved.
 *
 * This software is available to you under a choice of one of two
 * licenses.  You may choose to be licensed under the terms of the GNU
 * General Public License (GPL) Version 2, available from the file
 * COPYING in the main directory of this source tree, or the
 * BSD license below:
 *
 *     Redistribution and use in source and binary forms, with or
 *     without modification, are permitted provided that the following
 *     conditions are met:
 *
 *      - Redistributions of source code must retain the above
 *        copyright notice, this list of conditions and the following
 *        disclaimer.
 *
 *      - Redistributions in binary form must reproduce the above
 *        copyright notice, this list of conditions and the following
 *        disclaimer in the documentation and/or other materials
 *        provided with the distribution.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AWV
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <sys/time.h>
#include <unistd.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <assert.h>
#include <stdlib.h>
#include <sched.h>
#include <sys/utsname.h>
#include <dlfcn.h>

#include <mpi.h>
#include <rdma/fabric.h>
#include <rdma/fi_domain.h>
#include <rdma/fi_errno.h>
#include <rdma/fi_endpoint.h>
#include <rdma/fi_cm.h>
#include <rdma/fi_rma.h>
#include "ct_utils.h"

#ifndef CRAY_PMI_COLL

static int myRank;
static int debug;

static void pmi_coll_init(void)
{
	int len;
	int rank;
	int __attribute__((unused)) rc;

	rc = MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	assert(rc == MPI_SUCCESS);

	myRank = rank;

	MPI_Barrier(MPI_COMM_WORLD);
}
#else
#define pmi_coll_init()
#endif


void ctpm_Exit(void)
{
	MPI_Abort(MPI_COMM_WORLD, 0); /* Terminating application successfully" */
}

void ctpm_Abort(void)
{
	MPI_Abort(MPI_COMM_WORLD, -1); /* pmi abort called */
}

void ctpm_Barrier(void)
{
	int __attribute__((unused)) rc;

	rc = MPI_Barrier(MPI_COMM_WORLD);
	assert(rc == MPI_SUCCESS);
}

void ctpm_Init(int *argc, char ***argv)
{
	int __attribute__((unused)) rc;

	rc = MPI_Init(argc, argv);
	assert(rc == MPI_SUCCESS);

	pmi_coll_init();
}

void ctpm_Rank(int *rank)
{
	int __attribute__((unused)) rc;

	rc = MPI_Comm_rank(MPI_COMM_WORLD, rank);
	assert(rc == MPI_SUCCESS);
}

void ctpm_Finalize(void)
{
	MPI_Finalize();
}

void ctpm_Job_size(int *nranks)
{
	int __attribute__((unused)) rc;

	rc = MPI_Comm_size(MPI_COMM_WORLD, nranks);
	assert(rc == MPI_SUCCESS);
}

void ctpm_Allgather(void *src, size_t len_per_rank, void *targ)
{
	int rc;

	rc = MPI_Allgather (src, len_per_rank, MPI_BYTE, targ, len_per_rank, MPI_BYTE, MPI_COMM_WORLD);
	assert(rc == MPI_SUCCESS);

}

void ctpm_Bcast(void *buffer, size_t len, int root)
{
	int __attribute__((unused)) rc;

	rc = MPI_Bcast(buffer, len, MPI_BYTE, root, MPI_COMM_WORLD);
	assert(rc == MPI_SUCCESS);
}

